document.addEventListener("turbo:load", function () {
  const toggle = document.getElementById("user-toggle");
  const menu = document.getElementById("user-menu");

  if (toggle && menu) {
    toggle.addEventListener("click", () => {
      menu.classList.toggle("show");
      menu.classList.toggle("hidden");
    });

    document.addEventListener("click", function (e) {
      if (!toggle.contains(e.target) && !menu.contains(e.target)) {
        menu.classList.add("hidden");
        menu.classList.remove("show");
      }
    });
  }
});
