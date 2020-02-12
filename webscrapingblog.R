#web scraping blog
#import libs
library(rvest)
library(purrr)
#read site url
url = "http://books.toscrape.com/index.html"
page<-read_html(url)
#scraping test to extract each product's href`
selector = "li.col-xs-6:nth-child(1) > article:nth-child(1) > h3:nth-child(3) > a:nth-child(1)"
node<-html_node(page, selector)
node_text<-html_text(node)
node_links<-html_attr(node, "href")
node_links
