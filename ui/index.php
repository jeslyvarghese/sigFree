<html>
<head>
	<title>::SigFREE UI::</title>
	<style type="text/css" title="currentStyle">
			@import "jquery.dataTables.css";
		</style>
	<script type="text/javascript" src="scripts/jquery.js">
	</script>
	<script type="text/javascript" src="scripts/jquery.dataTables.min.js">
	</script>
	<script type="text/javascript">
		function get_data()
			{
				$.ajax({
					type:"GET",
					url:"ui_backend/db_ops.php",
					cache:false,
					success:function(jsonData)
					  {
					  	 jsonData = $.parseJSON(jsonData)
					  	 $('<tbody>').appendTo("#example");
					  	 for(index in jsonData)
					  	 {
					  	    id = jsonData[index]['id'].$id;
					  	    request = jsonData[index]['data'];
					  	    decoded = jsonData[index]['decoded_header'];
					  	    ascii = jsonData[index]['ascii_header'];
					  	    inst = jsonData[index]['inst_header'];
					  	    eifg = "<a href="+jsonData[index]['eifg']+">EIFG</a>";
					  	    valid_eifg = jsonData[index]['valid_eifg'];
                            inst_count = jsonData[index]['inst_count'];
                            decision = jsonData[index]['decision'];
                            insert_node = "<tr><td>"+id+"</td><td>"+request+"</td><td>"+decoded+"</td><td>"+ascii+"</td><td>"+inst+"</td><td>"+eifg+"</td><td>"+valid_eifg+"</td><td>"+inst_count+"</td><td>"+decision+"</td></tr>";
					  	    $(insert_node).appendTo("#example");
					  	 }
					  	 $('</tbody>').appendTo("#example");
					  	 $('#example').dataTable();
					  }

				});
			}
		$(document).ready(function() {
			get_data();
   		 });
	</script>
</head>
<body>
	<table id="example">
		<thead>
			<tr>
				<th>ID</th>
				<th>Data</th>
				<th>Decoded</th>
				<th>ASCII</th>
				<th>Instruction</th>
				<th>EIFG</th>
                <th>Valid EIFG</th>
                <th>Count</th>
                <th>Decision</th>
			</tr>
		</thead>
	</table>
	</body>
</html>