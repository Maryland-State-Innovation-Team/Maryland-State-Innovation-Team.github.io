/**
 * Injects a dismissible Terms & Conditions footer banner.
 * Features:
 * - LocalStorage persistence
 * - Accessibility: Focus management
 * - Accessibility: Screen reader support for external links
 * - Accessibility: Uses pre-existing DOM element for reliable aria-live announcements
 * * Usage:
 * window.initTermsBanner({
 * rootPath: '.'  // or '..' depending on file location
 * });
 */
window.initTermsBanner = function(config) {
    'use strict';

    // 1. Configuration & Defaults
    const options = Object.assign({
        rootPath: '.'
    }, config);

    const STORAGE_KEY = 'md_business_compass_tc_accepted';
    const CONTAINER_ID = 'md-tos-banner-container'; // Must match ID in index.html
    const DESCRIPTION_ID = 'tc-banner-description'; // ID for aria-describedby
    
    // 2. Check if already accepted
    if (localStorage.getItem(STORAGE_KEY) === 'true') {
        return; // Exit immediately if already accepted
    }

    // 3. Define CSS Styles
    const styles = `
        .tc-notification-banner {
            position: fixed;
            bottom: 0;
            left: 0;
            width: 100%;
            background-color: #1b1b1b;
            color: #ffffff;
            z-index: 40000;
            padding: 1rem 0;
            box-shadow: 0 -4px 10px rgba(0,0,0,0.25);
            border-top: 4px solid #e5a000;
            font-family: Source Sans Pro Web, Helvetica Neue, Helvetica, Roboto, Arial, sans-serif;
        }
        .tc-notification-banner__inner {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 2rem;
            max-width: 90rem;
            margin-left: auto;
            margin-right: auto;
            padding-left: 1rem;
            padding-right: 1rem;
        }
        .tc-notification-banner p {
            margin: 0;
            font-size: 0.9rem;
            line-height: 1.4;
        }
        .tc-notification-banner a {
            color: #ffffff;
            text-decoration: underline;
            font-weight: bold;
        }
        .tc-notification-banner a:hover {
            color: #e5a000;
        }
        .tc-notification-banner button {
            cursor: pointer;
            background-color: #ffffff;
            color: #1b1b1b;
            border: none;
            padding: 0.75rem 1.25rem;
            font-weight: 700;
            text-transform: uppercase;
            text-decoration: none;
            display: inline-block;
            font-size: 0.93rem;
            line-height: 0.9;
            border-radius: 0.25rem;
            flex-shrink: 0;
        }
        .tc-notification-banner button:hover {
            background-color: #f0f0f0;
            color: #005ea2;
        }
        /* Utility for screen readers */
        .tc-sr-only {
            position: absolute;
            width: 1px;
            height: 1px;
            padding: 0;
            margin: -1px;
            overflow: hidden;
            clip: rect(0, 0, 0, 0);
            white-space: nowrap;
            border: 0;
        }
        @media (max-width: 768px) {
            .tc-notification-banner {
                padding: 1rem;
            }
            .tc-notification-banner__inner {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }
            .tc-notification-banner button {
                width: 100%;
            }
        }
    `;

    // 4. Define HTML Structure
    // Uses ${options.rootPath} to ensure links work from subdirectories
    // Added ID to paragraph for aria-describedby association
    const htmlContent = `
        <div class="tc-notification-banner__inner">
            <p id="${DESCRIPTION_ID}">
                Welcome to the Maryland Community Business Compass. By using this website, you acknowledge that you have read and understand the 
                <a href="${options.rootPath}/terms-of-service/" target="_blank" rel="noopener noreferrer">Website Terms of Service<span class="tc-sr-only"> (opens in new tab)</span></a> and 
                <a href="${options.rootPath}/how-this-site-works/" target="_blank" rel="noopener noreferrer">How This Site Works<span class="tc-sr-only"> (opens in new tab)</span></a>, and agree to be bound by the terms, conditions, and notices therein. For future reference, a link to both the Website Terms of Service and How This Site Works can be found in the footer of each page of this website.
            </p>
            <button type="button" id="tc-accept-btn">Accept</button>
        </div>
    `;

    // 5. Injection Logic
    function injectBanner() {
        // Inject Styles
        const styleSheet = document.createElement("style");
        styleSheet.textContent = styles;
        document.head.appendChild(styleSheet);

        // Find existing container (preferred for accessibility) or create fallback
        let bannerDiv = document.getElementById(CONTAINER_ID);
        
        if (!bannerDiv) {
            // Fallback creation if HTML wasn't updated
            bannerDiv = document.createElement("div");
            bannerDiv.id = CONTAINER_ID;
            document.body.appendChild(bannerDiv);
        }

        // Apply classes and attributes
        bannerDiv.className = "tc-notification-banner";
        
        // ACCESSIBILITY CHANGE: 
        // We use role="region" instead of "alertdialog" to prevent it from being treated 
        // as a modal. This ensures it does not conflict with the Map Modal or Skip Link.
        // The 'aria-live' attribute on the container (in HTML) handles the announcement.
        bannerDiv.setAttribute("role", "region"); 
        bannerDiv.setAttribute("aria-label", "Terms of Service Notification");
        
        // Connect the container to the description text explicitly
        bannerDiv.setAttribute("aria-describedby", DESCRIPTION_ID);
        
        // Inject Content
        bannerDiv.innerHTML = htmlContent;

        // Bind Event Listener
        const btn = document.getElementById('tc-accept-btn');
        if (btn) {
            // NOTE: Auto-focus removed to preserve 'Skip to Main Content' functionality (RF-1)
            // and prevent conflicts with Map Modals (RF-25).

            btn.addEventListener('click', function() {
                try {
                    localStorage.setItem(STORAGE_KEY, 'true');
                    
                    // Remove banner content/styling but leave container if it was in HTML
                    bannerDiv.innerHTML = '';
                    bannerDiv.className = '';
                    bannerDiv.removeAttribute("role");
                    bannerDiv.removeAttribute("aria-label");
                    bannerDiv.removeAttribute("aria-describedby");
                    
                    // If we created it dynamically, remove it entirely. 
                    // If it was in HTML, we leave the empty node to maintain DOM stability.
                    if (!document.getElementById(CONTAINER_ID)) {
                        bannerDiv.remove(); 
                    }
                } catch (e) {
                    console.error('T&C Banner: Could not save to localStorage', e);
                }
            });
        }
    }

    // 6. Run Injection
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', injectBanner);
    } else {
        injectBanner();
    }
};