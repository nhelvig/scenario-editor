# this class will hold the project wide constants
$a = window.beats

window.beats.Constants =
  RESTURL: document.location.hostname +  ":" + document.location.port + "/via-rest-api"
  

window.beats.CrudFlag = {
    CREATE: 'CREATE',
    RETRIEVE: 'RETRIEVE',
    UPDATE: 'UPDATE',
    DELETE: 'DELETE'
  }