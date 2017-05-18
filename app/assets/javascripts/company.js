$(document).on('turbolinks:load', function () {
	var file = document.getElementById("map_imagem");
	file.onchange = function () {
		if (file.files.length > 0) {
			document.getElementById('filename').innerHTML = file.files[0].name;
		}
	};
});