// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function renew_validation_image(){
  now = new Date();
  var imageUrl = "/application/new_validation_image?time=" + now.getTime();
  document.validationImage.src = imageUrl;
}
