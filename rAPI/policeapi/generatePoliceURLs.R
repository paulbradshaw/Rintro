baseurl <- 'https://data.police.uk/api/stops-force?force=avon-and-somerset&date='
for (year in
c(2010,2011,2012,2013,2014,2015)
)
{ for (month in 01:12){
print(paste(baseurl, year,'-',month, sep=""))}
}
