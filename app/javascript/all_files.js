function toggleVisibility(id) {
    var element = document.getElementById(id);
    if (!element) return;
  
    var arrow = element.previousElementSibling.querySelector('.arrow');
    if (element.style.display === "none") {
      element.style.display = "block";
      arrow.innerHTML = '&#9660;'; // Down arrow
    } else {
      element.style.display = "none";
      arrow.innerHTML = '&#9654;'; // Right arrow
    }
  }
  
  function toggleFavorite(rvpId, starElement, event) {
    event.stopPropagation();
    const isFavorited = starElement.classList.contains('favorited');
    const favoritesList = document.getElementById('favorites-list');
  
    if (isFavorited) {
      // Remove from favorites
      starElement.classList.remove('favorited');
      starElement.innerHTML = '☆';
      const favoriteItem = document.getElementById(`favorite-item-${rvpId}`);
      if (favoriteItem) {
        favoritesList.removeChild(favoriteItem);
      }
      // Update the star in the main list
      updateMainListStar(rvpId, false);
    } else {
      // Add to favorites
      starElement.classList.add('favorited');
      starElement.innerHTML = '★';
      addToFavorites(rvpId, starElement);
      // Update the star in the main list
      updateMainListStar(rvpId, true);
    }
  }
  
  function addToFavorites(rvpId, starElement) {
    const rvpElement = starElement.closest('h2').cloneNode(true);
    const dropdownElement = starElement.closest('h2').nextElementSibling.cloneNode(true);
  
    rvpElement.querySelector('.favorite').onclick = function(event) {
      toggleFavorite(rvpId, this, event);
    };
  
    // Update cloned dropdown's ID and onclick for the arrow
    const clonedArrow = rvpElement.querySelector('.arrow');
    clonedArrow.onclick = function() {
      toggleVisibility(`favorite-files-${rvpId}`);
    };
    dropdownElement.id = `favorite-files-${rvpId}`;
  
    const listItem = document.createElement('li');
    listItem.id = `favorite-item-${rvpId}`;
    listItem.appendChild(rvpElement);
    listItem.appendChild(dropdownElement);
  
    document.getElementById('favorites-list').appendChild(listItem);
  }
  
  function updateMainListStar(rvpId, isFavorited) {
    const mainListStar = document.getElementById(`star-main-${rvpId}`);
    if (mainListStar) {
      mainListStar.classList.toggle('favorited', isFavorited);
      mainListStar.innerHTML = isFavorited ? '★' : '☆';
    }
  }