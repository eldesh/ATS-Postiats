######
#
# A simple Makefile
#
######

PATSCC=$(PATSHOME)/bin/patscc
PATSOPT=$(PATSHOME)/bin/patsopt

######
#
LDPATH :=
LDPATH := -L$(ATSHOME)/ccomp/lib
LDPATH += -L$(ATSHOME)/ccomp/lib64
LDPATH += -L$(PATSHOME)/utils/libatsopt
LDPATH += -L$(PATSHOME)/utils/libatsynmark
#
LIBRARY = -latsynmark -latsopt -lats -lgmp -lgc
#
ATSRUNTIME=$(ATSHOME)/ccomp/runtime
#
######
#
ATEXTING_MYLIB=\
$(PATSHOME)/utils/atexting/atexting_mylib.dats
#
######

all:: myatexting

######
#
myatexting: \
myatexting.dats ; \
$(PATSCC) -verbose -O2 -o $@ \
  -D_ATS_GCBDW \
  -DATS_MEMALLOC_GCBDW \
  myatexting.dats $(ATEXTING_MYLIB) \
  $(ATSRUNTIME)/ats_prelude.c $(LDPATH) $(LIBRARY)
#
######


######
#
regress:: \
data.atxt ; \
./myatexting -o data_atxt.dats -i $<
#
######

RMF=rm -f

######

clean:: ; $(RMF) *~
clean:: ; $(RMF) *_dats.c

######

cleanall:: clean
cleanall:: ; $(RMF) myatexting
cleanall:: ; $(RMF) data_atxt.dats

###### end of [Makefile] ######
