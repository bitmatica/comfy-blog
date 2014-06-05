# Bitmatica's ComfyBlog 

ComfyBlog is an simple blog management engine for [ComfortableMexicanSofa](https://github.com/comfy/comfortable-mexican-sofa) (for version >= 1.11).

This version of ComfyBlog has been customized specifically for use on the [Bitmatica Blog](http://www.bitmatica.com/blog). The changes made here are not intended to move upstream and are not expected to be useful for anyone else.

## Features
 
* Ability to set up multiple blogs per site
* User defined layout per blog

## Installation

Add gem definition to your Gemfile:

```ruby
gem 'comfy_blog', '~> 1.1.0'
```

Then from the Rails project's root run:
    
    bundle install
    rails generate comfy:blog
    rake db:migrate
    
Take a look inside your `config/routes.rb` file and you should see following lines there:

```ruby
comfy_route :blog_admin, :path => 'admin'
comfy_route :blog, :path => 'blog'
```

You should also find view templates in `/app/views/blog` folder. Feel free to adjust them as you see fit.

---

Copyright 2009-2013 Oleg Khabarov, [The Working Group Inc](http://www.twg.ca)
