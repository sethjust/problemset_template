LATEX = pdflatex --interaction=nonstopmode
REDIR = 1>/dev/null 2>/dev/null
RM = rm -f

RERUN = "(There were undefined references|Rerun to get ((cross-references|the bars) right|citations correct))"

TEXFILES = main.tex preamble/preamble.tex

.SILENT:

pdf: main.pdf

%.pdf: %.tex
	$(LATEX) $< #$(REDIR)
	egrep $(RERUN) $*.log && $(LATEX) $< $(REDIR); true
	egrep $(RERUN) $*.log && $(LATEX) $< $(REDIR); true
	echo "*** Errors for $< ***"; true
	egrep -i "((Reference|Citation).*undefined|Unaddressed TODO)" $*.log ; true

%.bbl: %.tex %.bib
	$(LATEX) $< $(REDIR)
	$(BIBTEX) $* $(REDIR); true
	$(LATEX) $< $(REDIR); true
	egrep -c $(RERUNBIB) $*.log $(REDIR) && ($(BIBTEX) $* $(REDIR);$(LATEX) $< $(REDIR)) ; true

%.sout: %.sage
	(!(diff $*.sage .$*.sage.bak) && (sage $< && cp $*.sage .$*.sage.bak)); true

%.sage: %.tex
	$(LATEX) $< $(REDIR); true

clean:
	$(RM) *.log *.aux *.toc *.tof *.tog *.bbl *.blg *.pdfsync *.d *.dvi *.out *.thm vc.tex

reallyclean:
	$(RM) *.pdf

sageclean:
	$(RM) *.sage *.sout .*.sage.bak
	$(RM) -r sage-plots-for-*
