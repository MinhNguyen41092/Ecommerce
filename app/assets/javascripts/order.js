$(document).on('turbolinks:load',function() {
  $('#update-status').on('change', 'select', function() {
    $('#update-status').submit();
    return false;
  });
});
