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
// Function to handle download PDF button click
function downloadPdf(pdfId, buttonElement) {
    // Check if the download button has already been clicked
    if (buttonElement.classList.contains('downloaded')) {
        console.log('PDF download already initiated.');
        return;
    }

    // Mark the download button as clicked to prevent multiple downloads
    buttonElement.classList.add('downloaded');

    const xhr = new XMLHttpRequest();
    xhr.open('GET', '/pdfs/download/' + pdfId, true);
    xhr.responseType = 'blob';

    xhr.onload = function () {
        if (xhr.status === 200) {
            const blob = xhr.response;

            // Extract the filename from the response headers
            const contentDisposition = xhr.getResponseHeader('Content-Disposition');
            const match = contentDisposition && contentDisposition.match(/filename="(.+)"/);
            const filename = match ? match[1] : 'downloaded.pdf';

            // Create a temporary URL for the blob
            const url = window.URL.createObjectURL(blob);

            // Create a hidden anchor element to trigger the download
            const a = document.createElement('a');
            a.style.display = 'none';
            a.href = url;
            a.download = filename; // Set the filename here
            document.body.appendChild(a);

            // Trigger a click event on the anchor element to initiate the download
            a.click();

            // Clean up resources
            window.URL.revokeObjectURL(url);
            document.body.removeChild(a);

            // Handle any further actions after successful download
            console.log('PDF downloaded successfully');
        } else {
            // Handle download failure
            console.error('PDF download failed');
        }
    };

    xhr.send();
}
// Event listener for download links
$(document).on('click', '.download-link', function (event) {
    event.preventDefault(); // Prevent the default link behavior
    const pdfId = $(this).data('pdf-id');
    downloadPdf(pdfId, this);
});

// Set a flag in sessionStorage when leaving the page
window.addEventListener('beforeunload', function () {
    sessionStorage.setItem('refreshRvpPage', 'true');
});

// Check if the flag exists and reload the page if needed
document.addEventListener('DOMContentLoaded', function () {
    const shouldRefresh = sessionStorage.getItem('refreshRvpPage');
    if (shouldRefresh === 'true') {
        sessionStorage.removeItem('refreshRvpPage'); // Remove the flag
        location.reload(); // Reload the page
    }
});