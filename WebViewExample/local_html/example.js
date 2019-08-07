function download(filename, text) {
    var pom = document.createElement('a');
    pom.setAttribute('href', 'data:image/png;base64,' + encodeURIComponent(text));
    pom.setAttribute('download', filename);
    pom.click();
}
