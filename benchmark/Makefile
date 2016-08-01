CXX ?= g++
CXXFLAGS := -std=c++11 -Wall -Isrc -I../src -pthread
debug:   CXXFLAGS += -O0 -ggdb
release: CXXFLAGS += -O3
LDFLAGS := -L.. -lpthread -ltbb -lnvmmalloc

SRCDIR := src
BUILDDIR := build
BINARIES := bench_fastalloc bench_linkedlist bench_recovery bench_alloc_free bench_alloc_free_alloc
TARGETS := $(addprefix $(BUILDDIR)/, $(BINARIES))

release: $(TARGETS)

debug: $(TARGETS)

$(BUILDDIR)/bench_recovery: $(SRCDIR)/bench_recovery.cpp $(SRCDIR)/common.h $(SRCDIR)/common.cpp
	@mkdir -p $(BUILDDIR)
	$(CXX) $(CXXFLAGS) -DUSE_NVM_MALLOC -o $@ $< $(SRCDIR)/common.cpp $(LDFLAGS)

$(BUILDDIR)/%: $(SRCDIR)/%.cpp $(SRCDIR)/common.h $(SRCDIR)/common.cpp
	@mkdir -p $(BUILDDIR)
	$(CXX) $(CXXFLAGS) -DUSE_MALLOC -o $@ $< $(SRCDIR)/common.cpp $(LDFLAGS)
	$(CXX) $(CXXFLAGS) -DUSE_NVM_MALLOC -o $@_nvm $< $(SRCDIR)/common.cpp $(LDFLAGS)
	#$(CXX) $(CXXFLAGS) -DUSE_NVM_MALLOC -DHAS_CLFLUSHOPT -o $@_nvm_clflushopt $(LDFLAGS) $< $(SRCDIR)/common.cpp
	#$(CXX) $(CXXFLAGS) -DUSE_NVM_MALLOC -DHAS_CLWB -o $@_nvm_clwb $(LDFLAGS) $< $(SRCDIR)/common.cpp
	$(CXX) $(CXXFLAGS) -DUSE_NVM_MALLOC -o $@_nvm_noflush $< $(SRCDIR)/common.cpp $(LDFLAGS)noflush
	$(CXX) $(CXXFLAGS) -DUSE_NVM_MALLOC -o $@_nvm_nofence $< $(SRCDIR)/common.cpp $(LDFLAGS)nofence
	$(CXX) $(CXXFLAGS) -DUSE_NVM_MALLOC -o $@_nvm_none $< $(SRCDIR)/common.cpp $(LDFLAGS)none

clean:
	@rm -rf $(BUILDDIR)

.PHONY: clean
