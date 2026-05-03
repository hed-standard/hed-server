document.addEventListener("DOMContentLoaded", function() {
    // Function to fix the icons
    function fixGitHubIcons() {
        // Furo puts icons in .content-icon-container
        // We look for links that point to GitHub
        const links = document.querySelectorAll(".content-icon-container a");

        links.forEach(link => {
            const href = link.getAttribute("href");
            if (!href) return;

            // Parse the URL to avoid substring-match bypass (e.g. http://evil.com/github.com)
            let parsed;
            try {
                parsed = new URL(href, window.location.origin);
            } catch {
                return;
            }

            // Check if it's a GitHub link (edit or blob/view)
            if (parsed.hostname === "github.com" || parsed.hostname.endsWith(".github.com")) {

                // If it's the Edit link, hide it
                if (parsed.pathname.includes("/edit/")) {
                    link.style.display = "none";
                    link.classList.add("hidden-edit-link"); // Marker for CSS
                }
                // If it's the View/Blob link, hijack it
                else if (parsed.pathname.includes("/blob/") || parsed.pathname.includes("/tree/")) {
                    // Change URL to repo root
                    link.href = "https://github.com/hed-standard/hed-server";
                    link.title = "Go to repository";
                    link.setAttribute("aria-label", "Go to repository");

                    // Remove any text content (like "View source") to ensure only icon shows
                    // But keep the SVG if we were using the original, but we are replacing it via CSS.
                    // Safest is to empty the text content but keep the element structure if needed.
                    // Actually, Furo puts an SVG inside. We want to hide that SVG and show our own background.
                    link.classList.add("github-repo-link"); // Add class for CSS targeting
                    link.style.display = "inline-flex";
                }
            }
        });
    }

    fixGitHubIcons();
});
