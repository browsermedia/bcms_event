# Event Module for BrowserCMS

An Event Module for BrowserCMS. Allows contributors to create and post new upcoming events. 

## Features

* Events - Contributors can create Event content that represent Single or Multiday Events.
* Events Lists - Allows a complete listing of all published events in a reverse chronological order along with names and descriptions.
* Event Details - Allows visitors to see the complete details for each Event, including the ability link to external Event Registration pages.
* SEO Friendly URLs - Each event will have its own custom URL to display itself.
* Customizable Views - Event listings and detail pages can be styled using editable Portlet views.

## Installation

The Event module installs like other BrowserCMS modules.

    gem install bcms_event

See http://guides.browsercms.org/installing_modules.html for further details.

### What's installed

When installing this module, it will create the following new pages/blocks.

* Events Page - A new Page 'Event' will be created at the root of the site, with an 'Event' portlet added. (Allows this page to display any Event)
* Events Route - A dynamic route to allow specific events to be shown by the Event page using a route like /events/:year/:month/:day/:slug

## Event Details

This module includes a new Event Content Type, with the following fields:

* Name
* Start and End Dates
* Location
* Contact Email
* Description - Used on the Event listing to summarize the Event.
* More Info URL
* Registration URL - Allows a link to external sites for registration.
* Category
* Tags
* Body - For the detailed view page.

