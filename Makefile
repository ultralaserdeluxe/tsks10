BUILDDIR = build
OUTDIR = pdf
TEXDIR = rapport
TEXFILE = tsks10-rapportmall.tex
PDFFILE = $(addsuffix .pdf,$(basename $(TEXFILE)))

$(TEXDIR)/$(OUTDIR)/$(PDFFILE): $(TEXDIR)/$(TEXFILE)
	cd $(dir $<) ; mkdir -p $(BUILDDIR)
	cd $(dir $<) ; pdflatex -output-directory=$(BUILDDIR) $(notdir $<)
	cd $(dir $<) ; mkdir -p $(OUTDIR)
	cd $(dir $<) ; mv $(BUILDDIR)/$(PDFFILE) $(OUTDIR)

.PHONY: clean
clean:
	rm -rf $(TEXDIR)/$(BUILDDIR)
	rm -rf $(TEXDIR)/$(OUTDIR)
