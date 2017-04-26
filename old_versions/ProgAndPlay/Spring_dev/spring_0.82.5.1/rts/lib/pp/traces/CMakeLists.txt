# Meresse (Spring supplied CMake build file) ---

SET(tracesSource
		"TracesParser"
		"TracesAnalyser"
		"Trace"
		"Sequence"
		"Event"
		"Call"
	)

ADD_LIBRARY(pp-traces STATIC EXCLUDE_FROM_ALL ${tracesSource})
SET_TARGET_PROPERTIES(pp-traces PROPERTIES COMPILE_FLAGS "${PIC_FLAG}")

# ---