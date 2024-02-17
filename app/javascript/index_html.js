// rvp_dropdown_search.js

document.addEventListener("DOMContentLoaded", function() {
    var searchInput = document.getElementById("rvpSearchInput");
    var options = document.querySelectorAll("#rvp option");
    
    searchInput.addEventListener("input", function() {
      var searchText = this.value.toLowerCase();
      
      options.forEach(function(option) {
        var text = option.textContent.toLowerCase();
        if (text.includes(searchText)) {
          option.style.display = "";
        } else {
          option.style.display = "none";
        }
      });
    });
  });