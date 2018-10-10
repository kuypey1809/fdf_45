$("#nav-menu li").on("click", function (e) {
  let id = e.target.getAttribute("id");

  $.get("get-product/" + id, function (res) {
    console.log(res);
  });
});
