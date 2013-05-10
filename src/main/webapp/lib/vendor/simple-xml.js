window.beats.fileText = '<?xml version="1.0" encoding="UTF-8"?>\
<scenario>\
  <settings/>\
  <NetworkSet>\
    <network dt="300">\
      <description/>\
      <position>\
        <point lat="37.865316577955674" lng="-122.29704350395201" elevation="0"/>\
      </position>\
      <NodeList>\
        <node type="" id="1">\
          <roadway_markers>\
            <marker name="" postmile="0"/>\
          </roadway_markers>\
          <outputs>\
            <output link_id="1"/>\
          </outputs>\
          <inputs/>\
          <position>\
            <point lat="37.86799330928557" lng="-122.2976803779602" elevation=""/>\
          </position>\
        </node>\
        <node type="" id="2">\
          <roadway_markers>\
            <marker name="" postmile="0"/>\
          </roadway_markers>\
          <outputs>\
            <output link_id="2"/>\
          </outputs>\
          <inputs>\
            <input link_id="1"/>\
          </inputs>\
          <position>\
            <point lat="37.866705913656425" lng="-122.29724049568176" elevation=""/>\
          </position>\
        </node>\
        <node type="" id="3">\
          <roadway_markers>\
            <marker name="" postmile="0"/>\
          </roadway_markers>\
          <outputs/>\
          <inputs>\
            <input link_id="2"/>\
          </inputs>\
          <position>\
            <point lat="37.86524062678921" lng="-122.29676842689514" elevation=""/>\
          </position>\
        </node>\
      </NodeList>\
      <LinkList>\
        <link lanes="4" lane_offset="0" length="150.8687318153821" type="electric_toll" id="1" in_sync="true">\
          <begin node_id="1"/>\
          <end node_id="2"/>\
          <roads>\
            <road name=""/>\
          </roads>\
          <dynamics type="CTM"/>\
          <shape>_bcfFrgmiVJCx@SxD}@DA</shape>\
        </link>\
        <link lanes="4" lane_offset="0" length="170.29121862518073" type="" id="2" in_sync="true">\
          <begin node_id="2"/>\
          <end node_id="3"/>\
          <roads>\
            <road name=""/>\
          </roads>\
          <dynamics type="CTM"/>\
          <shape>yybfFzdmiVnEeAjAWJC</shape>\
        </link>\
      </LinkList>\
    </network>\
  </NetworkSet>\
</scenario>'