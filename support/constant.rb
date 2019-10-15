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
  
end
