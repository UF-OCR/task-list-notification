require 'oci8'
require 'mail'
require 'celluloid/current'
require_relative 'support/constant'
require 'yaml'
require 'logger'

emails=[]
task_list = []
log = Logger.new(File.join(__dir__,"/logs/log_#{Time.now}.txt"))

class EmailJob
  include Celluloid

      def prepare_mail(task_list_assoc,i,output)
        const_object = Constant.new

        output.concat(const_object.get_output_const_1)
        output.concat("Good morning, #{ i[0] } #{ i[1] }. Below is your list of active task list items:")
        output.concat(const_object.get_output_const_3)

        task_list_assoc.each do |t|
          output.concat("<tr>
                                <td>#{t[0]}</td>
                                <td>#{t[1]}</td>
                                <td>#{t[3]}</td>
                          ")
          if !t[4].to_s.empty?
            output.concat("<td width='80px'>#{DateTime.parse(t[4].to_s).strftime("%m/%d/%Y")}</td>")
          else
            output.concat("<td></td>")
          end

          if !t[6].to_s.empty?
            comm_arr = t[6].to_s.split(';');
            output.concat("<td>")
            comm_arr.each do |c|
              if !c.to_s.empty?
                output.concat("#{c}<br>")
              end
            end
            output.concat("</td>")
          else
            output.concat("<td></td>")
          end
          output.concat("</tr>")
        end
        output.concat(const_object.get_output_const_2)
      end

      def send_mail(email, output)
        config = YAML.load_file(File.join(__dir__,'/support/config.yml'))
        options = { :address              => config["email"]["address"],
                    :port                 => 25,
        }

        #

        Mail.defaults do
          delivery_method :smtp, options
        end

        mail = Mail.new do
          to email
          from  config["email"]["from"]
          subject config["email"]["subject"]
          content_type 'text/html; charset=UTF-8'
          body output
        end

        mail.to_s

        mail.deliver
      end

      def process_mails(i,task_list,log)
        output = ""
        task_list_assoc = []
          task_list.each do |t|
            if t[5].to_s.include? i[2].to_s
              task_list_assoc.push(t)
            end
          end
          if task_list_assoc.length>0
            log.info "#{Time.now}: Preparing mail for #{ i[0] } #{ i[1] }"
            prepare_mail(task_list_assoc,i,output)
            send_mail(i[2],output)
            log.info "#{Time.now}: Mail sent to #{ i[2] }"
          else
            log.info "#{Time.now}: No task list for #{ i[0] } #{ i[1] }"
          end
        end
end

def get_data (emails, task_list)
  config = YAML.load_file(File.join(__dir__,'/support/config.yml'))
  conn = OCI8.new(config["database"]["username"].to_s,config["database"]["password"].to_s,"(DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = #{config['database']['hostname'].to_s})(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SID = #{config['database']['sid'].to_s})))")

  conn.exec(config["queries"]["userquery"]) do |r|
    emails.push(r);
  end

  sql_string = config["queries"]["tasklistquery"]
  conn.exec(sql_string) do |r|
    task_list.push(r)
  end
  conn.logoff
end

worker_pool    = EmailJob.pool(size: 5)
get_data(emails,task_list)
emails.each do |i|
   worker_pool.process_mails(i,task_list,log)
end