fetch('https://data.sfgov.org/resource/rqzj-sfat.json')
  .then(function (response) {
    return response.json();
  })
  .then(function (data) {
    appendData(data);
  })
  .catch(function (err) {
    console.log(err);
  });
  
function appendData(data) {
  var tBody = document.getElementById("gtData");
  for (var i = 0; i < data.length; i++) {
    var tr = document.createElement('tr');
	tBody.appendChild(tr);
	var td = document.createElement('td');
	td.innerHTML = data[i].applicant;
	tr.appendChild(td);
	var td = document.createElement('td');
	td.innerHTML = data[i].locationdescription;
	tr.appendChild(td);
	var td = document.createElement('td');
	td.innerHTML = data[i].fooditems;
	tr.appendChild(td);
  }
}