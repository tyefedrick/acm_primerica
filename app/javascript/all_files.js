// Removing the import statements as they may cause issues if your environment does not support ES6 modules
// import $ from 'jquery';
// window.$ = $;
// window.jQuery = $;

// Function to toggle the visibility of dropdown content
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

// Function to handle favorite button click
function toggleFavorite(rvpId, starElement, event) {
    event.stopPropagation();
    const isFavorited = starElement.classList.contains('favorited');

    // Update the favorite status in the database
    updateFavoriteStatus(rvpId, !isFavorited, function(response) {
        if (response.status === 'success') {
            if (response.favorite_id === null) {
                console.log("Favorite removed successfully:", response.message);
            } else {
                console.log("Favorite saved successfully with ID:", response.favorite_id);
            }

            // Update the star icon based on the response
            starElement.classList.toggle('favorited', !isFavorited);
            starElement.innerHTML = isFavorited ? '☆' : '★';
        } else {
            console.error("Error updating favorite status:", response.message);
        }
    });
}

// Function to update the main list star appearance based on favorite status
function updateMainListStar(rvpId, isFavorited) {
    const mainListStar = document.getElementById(`star-main-${rvpId}`);
    if (mainListStar) {
        mainListStar.classList.toggle('favorited', isFavorited);
        mainListStar.innerHTML = isFavorited ? '★' : '☆';
    }
}

// Function to update favorite status in the database using Fetch API
function updateFavoriteStatus(rvpId, isFavorite, callback) {
    const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

    fetch('/favorites/update', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': token,
        },
        body: JSON.stringify({ rvp_id: rvpId, favorite: isFavorite }),
    })
    .then(response => {
        if (!response.ok) {
            throw new Error(`HTTP Error! Status: ${response.status}`);
        }
        return response.json();
    })
    .then(data => {
        callback(data);
    })
    .catch(error => {
        console.error("Error updating favorite status:", error);
    });
}

// Additional function to add favorites (if needed)
function addToFavorites(rvpId, starElement) {
    // Implementation for adding to favorites
}

// Function to handle download PDF button click
function downloadPdf(pdfId, buttonElement) {
    $.get('/pdfs/download/' + pdfId, function(data) {
        // Handle success (you can display a success message if needed)
        console.log('PDF downloaded successfully');

        // If it was in the "Not Downloaded" section, move it to the "Downloaded" section
        const listItem = $(buttonElement).closest('li');
        if (listItem.closest('#not-downloaded-section').length > 0) {
            listItem.appendTo('#downloaded-list');
        }
    }).fail(function() {
        // Handle failure (you can display an error message if needed)
        console.error('PDF download failed');
    });
}
// Event listener for download links
$('.download-link').on('click', function(event) {
    event.preventDefault(); // Prevent the default link behavior
    const pdfId = $(this).data('pdf-id');
    downloadPdf(pdfId, this);
});
