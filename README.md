# MovieSearch Documentation

Welcome to MovieSearch, a user-friendly movie search app designed to make discovering movies easy and enjoyable. This guide will walk you through setting up the app, its features, and how to use it.

## Getting Started

### Installation

To begin, download MovieSearch from the GitHub repository. Once installed, open the app and follow the instructions.

### User Registration/Login

You can either create a new account or log in with your existing credentials. Having an account lets you personalize your experience.

## Home Page

### Top-Rated Movies

On the home page, you'll find a curated list of top-rated movies sourced from IMDb via the TMDB API. These movies promise quality entertainment.

### Infinite Scrolling

Scroll endlessly through the movie list. As you reach the bottom, more movies will load automatically.

## Search Page

### Movie Search

Easily find movies using the search bar. Just type the title, and relevant results will appear instantly.

### Sort and Filter

Refine your search results using sorting and filtering options. You can sort movies by year or popularity for a customized experience.

## Favorites

### Adding to Favorites

Create your own collection of favorite movies by adding them to your Favorites list.

### Viewing Favorites

Access and manage your favorite movies easily. Your Favorites list acts as your personal library.

## User Authentication

### Registration

Sign up for an account to access all MovieSearch features. Registration is simple and quick.

### Login

Log in securely to access your account and all features.

### Token Expiry

For added security, MovieSearch automatically logs you out after a period of inactivity.

## Implementation Details

### State Management

MovieSearch uses the Provider package for smooth app performance.

### API Calls

Backend and API calls are handled using the 'dio' package.

### Data Persistence

User data is stored securely using 'shared_preferences' for a consistent experience.

## Conclusion

MovieSearch offers a user-friendly experience, combining top-rated movies, easy search, and secure authentication. It's a great platform for exploring movies, built with professional standards in mind.