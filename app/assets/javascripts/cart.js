$(document).ready(function () {
  let products = JSON.parse(window.localStorage.getItem("cart"));
  let strAppend = "";
  let strSum = "";
  let sumary = 0;
  for (index in products) {
    let openTr = `<tr id="tr-${products[index].id}">`;
    let closeTr = "</tr>";
    let dataThProduct = `<td data-th="Product">
      <div class="row">
        <div class="col-sm-2 hidden-xs">
          <img src="${products[index].image}" alt="..." class="img-responsive"/>
        </div>
        <div class="col-sm-10">
          <h4 class="nomargin">${products[index].name}</h4>
          <p>${products[index].description}</p>
        </div>
      </div>
    </td>`;
    let dataThPrice = `<td id="price-${products[index].id}"
      data-th="Price">${products[index].price}
    </td>`;
    let dataThQuantity = `<td data-th="Quantity">
      <input id="quantity-${products[index].id}" type="number"
        class="form-control text-center"
        value="${products[index].quantity}"
        data-old-value="${products[index].quantity}">
    </td>`;
    let dataThTotal = `<td id="total-${products[index].id}" data-th="Subtotal"
      class="text-center">${products[index].total_price}
    </td>`;
    let action = `<td class="actions" data-th="">
      <button id="${products[index].id}" class="btn btn-info btn-sm update-cart">
        <i class="fa fa-refresh"></i>
      </button>
      <button class="btn btn-danger btn-sm destroy-cart"
        data-id="${products[index].id}">
        <i class="fa fa-trash-o"></i>
      </button>
    </td>`;
    strAppend += openTr + dataThProduct + dataThPrice + dataThQuantity;
    strAppend += dataThTotal + action + closeTr;
    sumary += products[index].total_price;
  }
  strSum = `<strong id="sumary">${sumary}</strong>`;
  $("#detail-cart").html(strAppend);
  $("#sumary-cart").html(strSum)

  $(".actions .update-cart").click(function (e) {
    let quantity = parseInt($("#quantity-" + $(this).attr("id")).val());
    if (quantity < 1) {
      alert("Quantity cant be negative");
      let oldValue = $("#quantity-" + $(this).attr("id")).attr("data-old-value");
      $("#quantity-" + $(this).attr("id")).val(oldValue);
      return;
    }
    let productId = $(this).attr("id");
    let productPrice = $("#price-" + productId).html();
    let oldTotalPrice = $("#total-" + productId).html();
    let arr = [];
    let newSumary = $("#sumary").html() ;
    let product = {
      id: productId,
      quantity: quantity,
      price: productPrice,
      total_price: productPrice * quantity,
    }
    if (!!window.localStorage.getItem("cart")) {
      arr = JSON.parse(window.localStorage.getItem("cart"));
      arr.forEach(function (element) {
        if (element.id == product.id) {
          element.quantity = product.quantity;
          element.total_price = product.price * element.quantity;
          newSumary -= oldTotalPrice;
          newSumary += element.total_price;
        }
      });
    }
    window.localStorage.setItem("cart", JSON.stringify(arr));
    $("#total-" + $(this).attr("id")).html(product.total_price);
    $("#sumary").html(newSumary);
  });

  $(".actions .destroy-cart").click(function (e){
    let arr = [];
    let productId = $(this).attr("data-id");
    let oldTotalPrice = $("#total-" + productId).html();
    let newSumary = $("#sumary").html();
    arr = JSON.parse(window.localStorage.getItem("cart"));
    arr.forEach(function (element, index) {
      if (element.id == productId) {
        console.log(arr, element, index);
        arr.splice(index, 1);
        newSumary -= oldTotalPrice;
      }
    });
    window.localStorage.setItem("cart", JSON.stringify(arr));
    $("#tr-" + productId).remove();
    $("#sumary").html(newSumary);
  });
});

$('#add-cart-to-order').on('click', function () {
  let products = JSON.parse(window.localStorage.getItem('cart'));
  let data = [];
  products.forEach(function (element) {
    let product = {
      id: element.id,
      quantity: element.quantity
    }
    data.push(product);
  });
  data = JSON.stringify(data)
  $.post("/orders", {demo: data}, function (res) {
    console.log(res);

    if (res.islogin) {
      window.localStorage.clear();
      $("#detail-cart").remove();
      $("#sumary").remove();
      alert(I18n.t("carts.added"));
    } else {
      window.location.href = '/login';
    }
  });
});

