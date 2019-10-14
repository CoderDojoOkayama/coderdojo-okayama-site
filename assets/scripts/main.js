$(document).ready(() => {
  $(".responsive-iframe").cbIframeSize();
  let hash = $(window.location.hash).is('*') ? window.location.hash : '#overview'
  window.location.hash = hash
  setDefaultHeroTab(hash)
});

$('.navbar-burger').on('click', e => {
  $('#navBurger').hasClass('is-active') ? $('#navBurger').removeClass('is-active') : $('#navBurger').addClass('is-active')
})