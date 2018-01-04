Title: md2bb
============

Description
------------
* Yet another conversion plugin from markdown to BB Code. (Development Still in Progress)

# Background
## What is markdown?
* [Markdown](https://en.wikipedia.org/wiki/Markdown) is an easy-to-read, easy-to-write language, with the aim of converting to HTML and other markup language.  
## What is BB Code?
* [Bulletin Board Code](https://en.wikipedia.org/wiki/BBCode) is a markup language similar to HTML, with a much simpler syntax (not simpler than markdown, though).  

# Motivation
## Why another md2bb? 
* We all like to use simple languages to mark up text. Many websites (eg. Steam) uses BB Code, but does not support markdow. It will be great if we can write markdown, and convert that into BB Code, without fiddling with BB Code syntax.
* Existing VIM plugins does not seem to include the capabilities to convert markdown to bbcode, and existing external tools has external dependencies or has licensing constraints. 

## Alternatives?
* feralhosting.github.io is a webpage for converting md 2 BB. For workflows involving converting small sized markdowns, this seems suitable 
* ohnonot/md2bb.pl: works on shell, but there's no licensing info (which also likely means it's copyright protected and cannot be used in other projects)
``` 
echo “* markdown” | perl  md2bb.pl > out
```
* md2bbc is a Node JS package that can be used in the same fashion, which takes additional code to take in stdin
* BBEdit is a Professional markdown BB editor tool
* kefirfromperm/kefirbb : convert many files to HTML, including BB and markdown

## Requirements
* Supports Mac, Linux, Windows
* Runs purely on Vimscript. No dependencies

## Installation Instructions
* TK

##License
MIT
