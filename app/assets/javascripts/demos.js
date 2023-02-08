$(document).on('turbolinks:load', function() {
  const tabs = document.querySelectorAll("#round-tabs ul li");
  const tabContentBoxes = document.querySelectorAll("#roundtabs-content > div.tab-content");

  tabs.forEach((tab) => {
    tab.addEventListener("click", () => {
      tabs.forEach(item => item.classList.remove("is-active"));
      tab.classList.add("is-active");
      const target = tab.dataset.target;
      tabContentBoxes.forEach(box => {
        if (box.getAttribute("id") === target) {
          box.classList.remove("is-hidden");
        } else {
          box.classList.add("is-hidden");
        }
      });
    });
  });
  const mainTabs = document.querySelectorAll("#main-tabs ul li");
  const mainTabContentBoxes = document.querySelectorAll("#maintabs-content > div.tab-content");

  mainTabs.forEach((tab) => { 
    tab.addEventListener("click", () => {
      mainTabs.forEach(item => item.classList.remove("is-active"));
      tab.classList.add("is-active");
      const target = tab.dataset.target;
      mainTabContentBoxes.forEach(box => {
        if (box.getAttribute("id") === target) {
          box.classList.remove("is-hidden");
        } else {
          box.classList.add("is-hidden");
        }
      });
    });
  });
});