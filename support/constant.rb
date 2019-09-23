class Constant
  OUTPUT_CONST_1 = "<style>
      table {
        border-collapse: collapse;
      }

  table, td, th {
    border: 1px solid black;
    max-width:1200px;
    word-wrap:break-word;
    text-align: left;
    padding: 5px;
  }
   td {
    vertical-align: top;
    }
  </style>"


  def get_output_const_1
    OUTPUT_CONST_1
  end

  OUTPUT_CONST_2 = "</tbody></table>
                    <br>Please do not reply to this automated e-mail. Please report any problems to <a href='OnCore-Support@ahc.ufl.edu'>OnCore-Support@ahc.ufl.edu</a>."


  def get_output_const_2
    OUTPUT_CONST_2
  end

  OUTPUT_CONST_3 = "<br><br><table>
                                            <thead>
                                                  <th>Protocol No.</th>
                                                  <th>Task List Name</th>
                                                  <th>Task List Item</th>
                                                  <th>Target Date</th>
                                                  <th>Communications</th>
                                            </thead>
                   <tbody>"


  def get_output_const_3
    OUTPUT_CONST_3
  end

  def get_task_list_query
     return  "select * from
 (
 select
 distinct
 spd.PROTOCOL_NO,
 stli.task_list_name,
 task.task_id,
 task.task_name,
 task.target_date,
 case when task.owner_type='Role' Then (select LISTAGG(email_address, ';') WITHIN GROUP (ORDER BY contact_id) staff
from
 sv_pcl_mgmt_staff
 where protocol_id=task.protocol_id and staff_role = task.staff_role and stop_date is null)
 else
 (select distinct email_address from SV_STAFF
 where staff_id=task.contact_id)
 end as staff_email,
 (select listagg (COMMUNICATION_DATE||': '||COMMUNICATION_TEXT, '; ') within group (order by COMMUNICATION_DATE) as NOTES from RV_TLI_TASK_COMMUNICATION
 where COMMUNICATION_TEXT != 'NULL value for Checklist Communication' and task_id=task.task_id) communication_text
 from
 rv_task_list_instance stli,
 rv_tli_task task,
 SV_TLI_TASK_DEPENDENCY task_dependency,
 (select task_id from RV_TLI_TASK where NA='Y' or COMPLETED_DATE is not null) complete_tasks,
 (select task_id, listagg (COMMUNICATION_DATE||': '||COMMUNICATION_TEXT, '; ') within group (order by COMMUNICATION_DATE) as NOTES from RV_TLI_TASK_COMMUNICATION where COMMUNICATION_TEXT != 'NULL value for Checklist Communication' group by TASK_ID) tcomm,
 sv_pcl_details spd
 where
 stli.task_list_id = task.task_list_id
 and complete_tasks.task_id = task_dependency.REQUIRED_TASK_ID
 and task.TASK_ID = task_dependency.TASK_ID
 and task.completed_date is null
 and task.NA = 'N'
 and task.protocol_id = spd.protocol_id
 ) taskTable
 order by target_date DESC nulls last, task_list_name asc"
  end

end