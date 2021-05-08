const SHEET_ID = 'YOUR_SHEET_ID_HERE'
var spreadSheet = SpreadsheetApp.open(DriveApp.getFileById(SHEET_ID))
function doGet(request) {
 
  var values = SpreadsheetApp.getActiveSheet().getDataRange().getValues();

  Logger.log(values)

  var data = {"notes": {},"todos": {}};
  var type = String(request);
  var isNotes = type.includes("isNotes=YES");

  if(!isNotes){
  for (var i = 0; i < values.length; i++) {
    row = values[i];
    data[
      "todos"
    ][i] = row[0];
    if(row[1] != ""){
    data["notes"][i] = row[1];
    }
  }
  }
  Logger.log(data);
  // Return result
  return ContentService
    .createTextOutput(JSON.stringify(data))
    .setMimeType(ContentService.MimeType.JSON);
}
function doPost(request) {

  var result = { "status": "SUCCESS" };
  try {
    switch (request.parameter.operationType) {
      case "update":
        const customRange = spreadSheet.getRange("A" + request.parameter.index)
        customRange.setValues([[request.parameter.encData]])
        break
      case "noteAdd":
        const noteRange = spreadSheet.getRange("B" + request.parameter.index)
        noteRange.setValues([[request.parameter.encData]])
        break
      case "noteDelete":
 
        spreadSheet.deleteRow(request.parameter.index)
      
        break
      case "noteUpdate":
        const noteUpdateRange = spreadSheet.getRange("B" + request.parameter.index)
        noteUpdateRange.setValues([[request.parameter.encData]])
        break
      case "insert":
        spreadSheet.insertRowBefore(request.parameter.index)
        const customRangeVar = spreadSheet.getRange("A" + request.parameter.index )
        customRangeVar.setValues([[request.parameter.encData]])
        break;
      case "batchAppend":
       var encListOfData = request.parameter.listOfEncData;
        var slicedString = encListOfData.slice(1,encListOfData.length - 1)
       if(request.parameter.listLength > 1){
        var listOfData = slicedString.split(', ')
        for (var i = 0; i < listOfData.length; i++) {
          spreadSheet.appendRow([listOfData[i]])
        }}
        else{
          spreadSheet.appendRow([slicedString])
        }
        break;

      case "delete":
      
        spreadSheet.deleteRow(request.parameter.index)
        break;
    }

  }
  catch (msg) {
    result = { "status": "FAILED", "msg": msg }
  }
  return ContentService
    .createTextOutput(JSON.stringify(result))
    .setMimeType(ContentService.MimeType.JSON);
}
