SRC = src/main.cpp src/TracesParser.cpp src/TracesAnalyser.cpp src/Trace.cpp src/Sequence.cpp src/Call.cpp src/Event.cpp
HEADERS = src/TracesParser.h src/TracesAnalyser.h src/Trace.h src/Sequence.h src/Call.h src/CallDef.h src/Event.h src/EventDef.h
OBJ = $(SRC:.cpp=.o) # replaces the .c from SRC with .o
EXE = parser.exe

CC = g++
CFLAGS = -Wall
SPRING_VERSION = spring_0.82.5.1
REP_TRACES = ../../Spring_dev/$(SPRING_VERSION)/rts/lib/pp/traces
LDFLAGS = -I../../Spring_dev/$(SPRING_VERSION)/mingwlibs/include
RM = rm

%.o: %.cpp         # combined w/ next line will compile recently changed .c files
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ -c $<

.PHONY : all     # .PHONY ignores files named all
all: $(EXE)      # all is dependent on $(EXE) to be complete

$(EXE): $(OBJ)   # $(EXE) is dependent on all of the files in $(OBJ) to exist
	$(CC) $(OBJ) -o $@

install: $(REP_TRACES)/params.json $(REP_TRACES)/feedbacks.xml $(REP_TRACES)/expert $(REP_TRACES)/TracesParser.cpp $(REP_TRACES)/TracesParser.h $(REP_TRACES)/TracesAnalyser.cpp $(REP_TRACES)/TracesAnalyser.h $(REP_TRACES)/Trace.cpp $(REP_TRACES)/Trace.h $(REP_TRACES)/Sequence.cpp $(REP_TRACES)/Sequence.h $(REP_TRACES)/Call.cpp $(REP_TRACES)/Call.h $(REP_TRACES)/CallDef.h $(REP_TRACES)/Event.cpp $(REP_TRACES)/Event.h $(REP_TRACES)/EventDef.h

$(REP_TRACES)/params.json: ./params.json
	cp ./params.json $(REP_TRACES)
	
$(REP_TRACES)/feedbacks.xml: ./feedbacks.xml
	cp ./feedbacks.xml $(REP_TRACES)
	
$(REP_TRACES)/expert: ./expert
	cp -r ./expert $(REP_TRACES)

$(REP_TRACES)/TracesParser.cpp: src/TracesParser.cpp
	cp src/TracesParser.cpp $(REP_TRACES)

$(REP_TRACES)/TracesParser.h: src/TracesParser.h
	cp src/TracesParser.h $(REP_TRACES)
	
$(REP_TRACES)/TracesAnalyser.cpp: src/TracesAnalyser.cpp
	cp src/TracesAnalyser.cpp $(REP_TRACES)

$(REP_TRACES)/TracesAnalyser.h: src/TracesAnalyser.h
	cp src/TracesAnalyser.h $(REP_TRACES)
	
$(REP_TRACES)/Trace.cpp: src/Trace.cpp
	cp src/Trace.cpp $(REP_TRACES)
	
$(REP_TRACES)/Trace.h: src/Trace.h
	cp src/Trace.h $(REP_TRACES)
	
$(REP_TRACES)/Sequence.cpp: src/Sequence.cpp
	cp src/Sequence.cpp $(REP_TRACES)
	
$(REP_TRACES)/Sequence.h: src/Sequence.h
	cp src/Sequence.h $(REP_TRACES)
	
$(REP_TRACES)/Call.cpp: src/Call.cpp
	cp src/Call.cpp $(REP_TRACES)
	
$(REP_TRACES)/Call.h: src/Call.h
	cp src/Call.h $(REP_TRACES)
	
$(REP_TRACES)/CallDef.h: src/CallDef.h
	cp src/CallDef.h $(REP_TRACES)
	
$(REP_TRACES)/Event.cpp: src/Event.cpp
	cp src/Event.cpp $(REP_TRACES)
	
$(REP_TRACES)/Event.h: src/Event.h
	cp src/Event.h $(REP_TRACES)
	
$(REP_TRACES)/EventDef.h: src/EventDef.h
	cp src/EventDef.h $(REP_TRACES)

.PHONY : clean   # .PHONY ignores files named clean
clean:
	$(RM) $(OBJ)$(EXE)