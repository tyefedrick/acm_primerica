// Removing the import statements as they may cause issues if your environment does not support ES6 modules
// import $ from 'jquery';
// window.$ = $;
// window.jQuery = $;

// Function to toggle the visibility of dropdown content
function toggleVisibility(id) {
    var element = document.getElementById(id);
    if (element) {
        var arrow = element.previousElementSibling.querySelector('.arrow');
        if (element.style.display === "none") {
            element.style.display = "block";
            arrow.innerHTML = '&#9660;'; // Down arrow
        } else {
            element.style.display = "none";
            arrow.innerHTML = '&#9654;'; // Right arrow
        }
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
                // If removed from favorites, remove from the favorites section
                removeFavoriteFromSection(rvpId);
            } else {
                console.log("Favorite saved successfully with ID:", response.favorite_id);
                // If added to favorites, add to the favorites section
                addFavoriteToSection(rvpId);
            }

            // Update the star icon based on the response
            starElement.classList.toggle('favorited', !isFavorited);
            starElement.innerHTML = isFavorited ? '☆' : '★';
        } else {
            console.error("Error updating favorite status:", response.message);
        }
    });
}

// Function to add favorite to the favorites section in the UI
function addFavoriteToSection(rvpId) {
    // Get the RVP element
    const rvpElement = document.getElementById(`rvp-${rvpId}`);
    if (rvpElement) {
        // Clone the RVP element and append it to the favorites section
        const clone = rvpElement.cloneNode(true);
        document.getElementById('favorites-section').appendChild(clone);
    }
}

// Function to remove favorite from the favorites section in the UI
function removeFavoriteFromSection(rvpId) {
    // Get the RVP element from the favorites section
    const favoriteElement = document.getElementById(`rvp-${rvpId}-favorite`);
    if (favoriteElement) {
        // Remove the RVP element from the favorites section
        favoriteElement.remove();
    }
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

            // Refresh the page after successful download
            location.reload();
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

document.addEventListener('DOMContentLoaded', function () {
    // Event listener for download links in the favorites section
    $(document).on('click', '.download-link-favorite', function (event) {
        event.preventDefault(); // Prevent the default link behavior
        const pdfId = $(this).data('pdf-id');
        downloadPdf(pdfId, this);
    });

    // Event listener for favorite toggle in the favorites section
    $(document).on('click', '.favorite-favorite', function (event) {
        event.stopPropagation();
        const rvpId = $(this).data('rvp-id');
        toggleFavorite(rvpId, this, event);
    });

    // Event listener for toggling visibility of dropdown content in the favorites section
    $(document).on('click', '.rvp-favorite', function (event) {
        const rvpId = $(this).data('rvp-id');
        toggleVisibility(`files_${rvpId}-favorite`);
    });

    const shouldRefresh = sessionStorage.getItem('refreshRvpPage');
    if (shouldRefresh === 'true') {
        sessionStorage.removeItem('refreshRvpPage'); // Remove the flag
        location.reload(); // Reload the page
    }
});

// Function to handle expanding/collapsing favorites section and load PDFs
function toggleFavoriteSection(rvpId) {
    const filesSection = document.getElementById(`files_${rvpId}-favorite`);
    if (filesSection) {
        if (filesSection.style.display === 'none') {
            // Show the files section and load PDFs if not already loaded
            filesSection.style.display = 'block';
            if (!filesSection.dataset.loaded) {
                loadFavoritePdfList(rvpId);
                filesSection.dataset.loaded = true;
            }
        } else {
            // Hide the files section
            filesSection.style.display = 'none';
        }
    }
}


// Function to load PDF list for a favorited RVP via AJAX
function loadFavoritePdfList(rvpId) {
    fetch(`/rvps/${rvpId}/pdfs`)
        .then(response => response.json())
        .then(data => {
            const notDownloadedList = document.getElementById(`not-downloaded-list-${rvpId}-favorite`);
            const downloadedList = document.getElementById(`downloaded-list-${rvpId}-favorite`);
            if (notDownloadedList && downloadedList) {
                data.pdfs.forEach(pdf => {
                    const full_name = pdf.full_name;
                    const listItem = `
                        <li>
                            ${pdf.downloaded_by_user ? '' : '<input type="checkbox" name="selected_files[]" value="' + pdf.id + '">'}
                            ${full_name} AMC Form ${pdf.formatted_date}.pdf
                            <a href="/pdfs/download/${pdf.id}" class="download-link-favorite" data-pdf-id="${pdf.id}" download>Download</a>
                        </li>`;
                    if (pdf.downloaded_by_user) {
                        downloadedList.insertAdjacentHTML('beforeend', listItem);
                    } else {
                        notDownloadedList.insertAdjacentHTML('beforeend', listItem);
                    }
                });
            }
        })
        .catch(error => console.error('Error loading PDF list:', error));
}

// Event listener for toggling visibility of dropdown content in the favorites section
$(document).on('click', '.rvp-favorite', function (event) {
    const rvpId = $(this).data('rvp-id');
    toggleFavoriteSection(rvpId);
});