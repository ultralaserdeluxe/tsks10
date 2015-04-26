.PHONY: rapport
rapport:
	cd rapport ; pdflatex tsks10-rapportmall.tex

.PHONY: clean
clean:
	cd rapport ; rm *.aux *.log tsks10-rapportmall.tex
