#web scraping blog
#import libs
library(rvest)
library(purrr)
#read site url
url = "http://books.toscrape.com/index.html"
web_page<-read_html(url)
#scraping test to extract each product's href`
selector = "li.col-xs-6:nth-child(1) > article:nth-child(1) > h3:nth-child(3) > a:nth-child(1)"
node<-html_node(web_page, selector)
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
  page<-read_html(url)
  nodo<-html_nodes(page, selector)
  nodo_text<-html_text(nodo)
  nodo_links<-html_attr(nodo, "href")
  nodo_links
}
#Function test
first_page_books = linksGetter(all_pages[1])
first_page_books
#All books URls
books_urls<-sapply(all_pages, linksGetter)
books_urls<- as.vector(books_urls)
books_urls<-paste0("http://books.toscrape.com/catalogue/", books_urls)
books_urls

url = "http://books.toscrape.com/catalogue/tipping-the-velvet_999/index.html"
web_page<-read_html(url)
#extracting book's name
name_selector<-"h1"
name_node<-html_node(web_page, name_selector)
name_text<-html_text(name_node)
name_text

#extracting book's price
price_selector <-"p.price_color"
price_node<-html_node(web_page, price_selector)
price_text<-html_text(price_node)
price_text

#extracting review as number
reviews<-"p.star-rating"
reviews_node<-html_node(web_page, reviews)
reviews_text<-html_attr(reviews_node, "class")
reviews_text = substr(reviews_text, 13, 17)
reviews_number = switch(reviews_text, "Zero" = 0,"One" = 1, "Two" = 2, "Three" = 3, "Four" = 4, "Five" = 5,)
reviews_number

#extracting product details table
#PRODUCT DETAIL
details_selector = ".table"
details_node<-html_node(web_page, details_selector)
table_node_table<-html_table(details_node)
table_values<-table_node_table$X2
table_dataframe = data.frame(t(table_values))
table_names = table_node_table$X1
colnames(table_dataframe) = table_names
table_dataframe
View(table_dataframe)
str(table_dataframe)

#book details result
single_book_results = c(name_text, price_text, reviews_number, as.character(table_dataframe$Availability))
single_book_results

# BOOK DETAILS FUNCTION
getDetails = function(url){
  web_page<-read_html(url)
  #extracting book's name
  name_selector<-"h1"
  name_node<-html_node(web_page, name_selector)
  name_text<-html_text(name_node)

  #extracting book's price
  price_selector <-"p.price_color"
  price_node<-html_node(web_page, price_selector)
  price_text<-html_text(price_node)

  #extracting review as number
  reviews<-"p.star-rating"
  reviews_node<-html_node(web_page, reviews)
  reviews_text<-html_attr(reviews_node, "class")
  reviews_text = substr(reviews_text, 13, 17)
  reviews_number = switch(reviews_text, "Zero" = 0,"One" = 1, "Two" = 2, "Three" = 3, "Four" = 4, "Five" = 5,)

  #extracting product details table
  details_selector = ".table"
  details_node<-html_node(web_page, details_selector)
  table_node_table<-html_table(details_node)
  table_values<-table_node_table$X2
  table_dataframe = data.frame(t(table_values))
  table_names = table_node_table$X1
  colnames(table_dataframe) = table_names
  
  #book details result
  single_book_results = c(name_text, price_text, reviews_number, as.character(table_dataframe$Availability))
  single_book_results
  }

single_book_test = getDetails(books_urls[1])
single_book_test

#Scraping result

scraping_results = sapply(books_urls, getDetails)

#CREATE DATAFRAME
scraping_results = t(scraping_results)
colnames(scraping_results) = c("Book Name", "Price",  "Rating", "Availability")
rownames(scraping_results) = c(1:1000)
write.csv(scraping_results, file="bookScrapingResults")

