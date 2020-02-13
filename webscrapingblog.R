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

full_url<-paste0("http://books.toscrape.com/",node_links)
full_url

library(stringr)
single_page = "http://books.toscrape.com/catalogue/page-3.html"
pages_list<-c(1:50)
all_pages<-str_replace(single_page, "page-3", paste0("page-",pages_list))
all_pages

#URL LIST AFTER PAGINATION
linksGetter<-function(url){
  selector = "article > h3 > a"
  pagina<-read_html(url)
  nodo<-html_nodes(pagina, selector)
  nodo_text<-html_text(nodo)
  nodo_links<-html_attr(nodo, "href")
  nodo_links
}
#Function test
first_page_books = linksGetter(pag[1])
first_page_books
#All books URls
books_urls<-sapply(all_pages, linksGetter)
books_urls<- as.vector(books_urls)
books_urls<-paste0("http://books.toscrape.com/catalogue/", books_urls)
books_urls
