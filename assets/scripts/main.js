$(document).ready(() => {
  $(".responsive-iframe").cbIframeSize();
});

$('.navbar-burger').on('click', e => {
  $('#navBurger').hasClass('is-active') ? $('#navBurger').removeClass('is-active') : $('#navBurger').addClass('is-active')
})

$('.hero-foot>.tabs .tab').on('click', function() {
  $('.hero-foot>.tabs .tab').removeClass('is-active')
  $(this).addClass('is-active')
  $('main>section').addClass('is-hidden')
  const displayElement = $(this).attr('data-target')
  $(`#${displayElement}`).removeClass('is-hidden')
})