$(document).ready(() => {
  $(".responsive-iframe").cbIframeSize();
});

$('.navbar-burger').on('click', e => {
  $('#navBurger').hasClass('is-active') ? $('#navBurger').removeClass('is-active') : $('#navBurger').addClass('is-active')
})