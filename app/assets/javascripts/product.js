$(function() {
  $("#products .pag").on("click", ".pag", function() {
    $.getScript(this.href);
    return false;
  });
  $("#search").submit(function() {
    $.get($("#search").attr("action"), $("#search").serialize(), null, "script");
    return false;
  });
});
