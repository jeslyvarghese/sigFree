<?php
	function connect()
		{
			$connection = new Mongo();
			$db = $connection->selectDB("sigfree");
			return $db;
		}
	function get_all($db)
		{
			$collection = new MongoCollection($db,'logs');
			$cursor = $collection->find();	
			$output = array();
			$index=0;
			foreach ($cursor as $key => $value) {
				$output[$index]['id'] = $value['_id'];
				$output[$index]['data'] = $value['Data'];
				$output[$index]['decoded_header'] = $value['Decoded_Header'];
				$output[$index]['ascii_header'] = $value['ASCII_Filtered_Header'];
				$output[$index]['inst_header'] = $value['Instructionized_Header'];
				$output[$index]['eifg'] = $value['Header_EIFG'];
				$output[$index]['valid_eifg'] = $value['Valid_EIFG'];
				$output[$index]['inst_count'] = $value['Valid_Count'];
				$output[$index]['decision'] = $value['Decision'];
				$index++;
			}
			$output = json_encode($output);
			echo $output;
		}
	$db = connect();
	get_all($db);
?>