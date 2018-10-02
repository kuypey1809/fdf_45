$("#nav-menu li").on("click", function (e) {
  let id = e.target.getAttribute("id");
  $.get("/get-product/" + id, function (res) {
    console.log(res);
  });
});
$("#up-quantity").on("click", function () {
  let quantity = parseInt($("#quantity").val());
  $("#quantity").val(quantity + 1);
});
$("#down-quantity").on("click", function () {
  let quantity = parseInt($("#quantity").val());
  if (quantity > 1) {
    $("#quantity").val(quantity - 1);
  }
});

$("#btn-add-to-cart").on("click", function () {
  let quantity = parseInt($("#quantity").val());
  let productId = $("#product-id").val();
  let productPrice = $("#product-price").val();
  let productName = $("#product-name").html();
  let productDescription = $("#product-description").html();
  let productImage = $("#product-image").val();
  let arr = [];
  let product = {
    id: productId,
    quantity: quantity,
    price: productPrice,
    total_price: productPrice * quantity,
    name: productName,
    description: productDescription,
    image: productImage,
  }
  let isDuplicate = false;
  if (!!window.localStorage.getItem("cart")) {
    arr = JSON.parse(window.localStorage.getItem("cart"));
    arr.forEach(function (element) {
      if (element.id == product.id) {
        element.quantity += product.quantity;
        element.total_price = product.price * element.quantity;
        isDuplicate = true;
      }
    });
  }
  if (!isDuplicate) {
    arr.push(product);
  }
  window.localStorage.setItem("cart", JSON.stringify(arr));
  alert(I18n.t("products.added"));
});
