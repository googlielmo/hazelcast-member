HAZELCAST_VERSION=3.9.3
HAZELCAST_MEMBER_REV=2

DIST=build/dist
HZ_BIN=${DIST}/bin
HZ_ETC=${DIST}/etc

.PHONY: all clean cleanall cleandist download dist package

all: download package

clean: cleandist
	# cleaning up local maven repo
	rm -fr build/mvnw

cleanall:
	# cleaning up everything
	rm -fr build
	rm -f archive/hazelcast-member-${HAZELCAST_VERSION}_${HAZELCAST_MEMBER_REV}.tar.gz

cleandist:
	# cleaning up dist
	rm -fr ${DIST}

dist:
	# copying docs and scripts
	mkdir -p ${DIST}
	mkdir -p ${HZ_BIN}
	mkdir -p ${HZ_ETC}
	cp README-Running.txt ${DIST}/README.txt
	cp hazelcast.xml ${HZ_ETC}
	cp src/hazelcast-member ${HZ_BIN}
	cp src/*.sh ${HZ_BIN}
	for f in ${HZ_BIN}/* ; do sed -i '.bak' 's/$${hazelcast_version}/${HAZELCAST_VERSION}/g' $$f ; done
	rm -f ${HZ_BIN}/*.bak
	chmod +x ${HZ_BIN}/*

download:
	# downloading Hazelcast artifacts
	HAZELCAST_VERSION=${HAZELCAST_VERSION} ./dl-artifacts.sh

package: dist
	# creating package
	mkdir -p archive
	tar -zcf archive/hazelcast-member-${HAZELCAST_VERSION}_${HAZELCAST_MEMBER_REV}.tar.gz -C ${DIST} README.txt bin lib etc
	@echo "Archive archive/hazelcast-member-${HAZELCAST_VERSION}_${HAZELCAST_MEMBER_REV}.tar.gz created successfully"
