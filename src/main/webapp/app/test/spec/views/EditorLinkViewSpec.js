describe("EditorLinkView", function() {
  $a = window.beats;
  
  var testsLinkGeo = [
      {
        desc: "Geo Tab: 'Lanes' field is saved",
        id: "#lanes",
        val: "changed",
        type: "blur",
        field: "lanes"
      },
      {
        desc: "Geo Tab: 'Lanes Offset' field is saved",
        id: "#lane_offset",
        val: "changed",
        type: "blur",
        field:"lane_offset"
      },
      {
        desc: "Geo Tab: 'Length' field is saved",
        id: "#length",
        val: "changed",
        type: "blur",
        field:"length"
      }
  ];
  // These tests should be moved into profile editor at a later point
/*  var testsFD = [
      {
        desc: "FD Tab: 'Free Flow Speed' field calls saveFD",
        id: "#free_flow_speed",
        val: "changed",
        type: "blur",
        field:"free_flow_speed"
      },
      {
        desc: "FD Tab: 'Congestion Speed' field calls saveFD",
        id: "#congestion_speed",
        val: "changed",
        type: "blur",
        field:"congestion_speed"
      },
      {
        desc: "FD Tab: 'Critical Speed' field calls saveFD",
        id: "#critical_speed",
        val: "changed",
        type: "blur",
        field:"critical_speed"
      },
      {
        desc: "FD Tab: 'Capacity' field calls saveFD",
        id: "#capacity",
        val: "changed",
        type: "blur",
        field:"capacity"
      },
      {
        desc: "FD Tab: 'Capacity Drop' field calls saveFD",
        id: "#capacity_drop",
        val: "changed",
        type: "blur",
        field:"capacity_drop"
      },
      {
        desc: "FD Tab: 'Standard Deviation Capacity' field calls saveFD",
        id: "#std_dev_capacity",
        val: "changed",
        type: "blur",
        field:"std_dev_capacity"
      },
      {
        desc: "FD Tab: 'Standard Deviation Congestion' field calls saveFD",
        id: "#std_dev_congestion",
        val: "changed",
        type: "blur",
        field:"std_dev_congestion"
      },
      {
        desc: "FD Tab: 'Standard Deviation Free Flow Speed' field calls saveFD",
        id: "#std_dev_free_flow_speed",
        val: "changed",
        type: "blur",
        field:"std_dev_free_flow_speed"
      }
    ];
  var testsDemand = [
      {
        desc: "Demand Tab: 'Knob' field calls saveDP",
        id: "#knob",
        val: "changed",
        type: "blur",
        field:"knob"
      }
      //{
      //  desc: "Demand Tab: 'Demand Profile' field calls saveDP",
      //  id: "#dp_text",
      //  val: "changed",
      //  type: "blur",
      //  field:"text"
      //},
    ];
*/
  var testsCapacity = [
      {
        desc: "Capacity Tab: 'Capecity Profile' field calls saveCP",
        id: "#cp_text",
        val: "changed",
        type: "blur",
        field:"text"
      }
  ];
  
  beforeEach(function() {
    loadFixtures('editor.link.view.fixture.html');
    spyOn($a.EditorLinkView.prototype, 'doSplit').andCallThrough();
    spyOn($a.EditorLinkView.prototype, 'subDivide').andCallThrough();
    spyOn($a.EditorLinkView.prototype, 'addLeftTurn').andCallThrough();
    spyOn($a.EditorLinkView.prototype, 'addRightTurn').andCallThrough();
    spyOn($a.EditorLinkView.prototype, 'chooseName').andCallThrough();
    spyOn($a.EditorLinkView.prototype, 'reverseLink').andCallThrough();
    spyOn($a.EditorLinkView.prototype, 'geomLine').andCallThrough();
    spyOn($a.EditorLinkView.prototype, 'geomRoad').andCallThrough();
    spyOn($a.EditorLinkView.prototype, 'save').andCallThrough();
    spyOn($a.EditorLinkView.prototype, 'saveName').andCallThrough();
    spyOn($a.EditorLinkView.prototype, 'saveType').andCallThrough();
    spyOn($a.EditorLinkView.prototype, 'saveInSync').andCallThrough();
//    spyOn($a.EditorLinkView.prototype, 'saveFD').andCallThrough();
//    spyOn($a.EditorLinkView.prototype, 'saveDP').andCallThrough();
    spyOn($a.EditorLinkView.prototype, 'saveCP').andCallThrough();
//    spyOn($a.EditorLinkView.prototype, 'saveDPTime').andCallThrough();
    spyOn($a.EditorLinkView.prototype, 'saveCPTime').andCallThrough();
    scen = scenarioAndFriends();
    this.view = new $a.EditorLinkView({
      elem: 'link', 
      models: [scen.link1]
    });
  });
  
  afterEach(function() {
    this.view.remove();
  });
  
  describe("Instantiation", function() {
    it("should create a div element", function() {
        expect(this.view.el.nodeName.toLowerCase()).toEqual("div");
      });
      
      it('Is backed by a model instance', function() {
        expect(this.view.models).toBeDefined();
      });
      
      it("should should have id", function() {
        val = "link-dialog-form-" + this.view.models[0].cid;
        expect(this.view.el.id).toEqual(val);
      });
  
      it("should should have title", function() {
        val = "Link Editor: " + this.view.models[0].road_names();
        expect(this.view.el.title).toEqual(val);
      });
  
  
  });
  
  describe("Rendering", function() {
    beforeEach(function() {
      this.view.render();
    });
    it("returns the view object", function() {
      expect(this.view.render()).toEqual(this.view);
    });
    
    it("produces the correct HTML", function() {
      this.view.render();
      var label = '<label for="link-name">Link Name</label>';
      expect(this.view.el.innerHTML).toContain(label);
    });
    
    it("should should have correct type selected", function() {
      val = this.view.models[0].link_type().name();
      elem = $($(this.view.el).find('#link_type option:selected')).attr("name");
      expect(elem).toEqual(val);
    });
    
    //checks that template was created correctly
    //Note: the lane_offset check calls toString to force NaN to a string
    it("has the correct text content", function() {
      var count = 0;
      var model = this.view.models[0];
      //fdp = model.get('fundamentaldiagramprofile');
      //fd = fdp.get('fundamentaldiagram')[0] || null;
      cp = model.get('capacity') || null;
      //dp = model.get('demand') || null;
      
      var v = {
        name: model.link_name(),
        lanes: model.lanes(),
        insync: model.get('in_sync'),
        laneOffset: model.get('lane_offset'),
        length: model.get('length') || '',
        //freeFlowSpeed: fd.get('free_flow_speed') || '',
        //criticalSpeed: fd.get('critical_speed') || '',
        //capacity: fd.get('capacity') || '',
        //jamDensity: fd.get('jam_density') || '',
        //capacityDrop: fd.get('capacity_drop') || '',
        //congestionSpeed: fd.get('congestion_speed') || '',
        //capacityStandardDev: fd.get('std_dev_capacity') || '',
        //congestionStandardDev: fd.get('std_dev_congestion') || '',
        //freeFlowStdDev: fd.get('std_dev_free_flow') || '',
        cpStart: $a.Util.convertSecondsToHoursMinSec(0),
        cpSample: $a.Util.convertSecondsToHoursMinSec(0),
        capacityProfile: '',
        //knob: dp.get('knob') || '',
        //dpStart: $a.Util.convertSecondsToHoursMinSec(dp.get('start_time') || 0),
        //dpSample: $a.Util.convertSecondsToHoursMinSec(dp.get('dt') || 0),
        // Demand Profile Text box no longer in use
        //demandProfile: dp.get('text') || '',
      };
      
      var view = this.view;
      expect(view.$('#link_name')).toHaveValue(v.name);
      expect(view.$('#lanes')).toHaveValue(v.lanes);
      expect(view.$('#lane_offset')).toHaveValue(v.laneOffset.toString());
      expect(view.$('#length')).toHaveValue(v.length);
      expect(view.$('#capacity')).toHaveValue(v.capacity);
      expect(view.$('#jam_density')).toHaveValue(v.jamDensity);
      expect(view.$('#free_flow_speed')).toHaveValue(v.freeFlowSpeed);
      expect(view.$('#critical_speed')).toHaveValue(v.criticalSpeed);
      expect(view.$('#capacity_drop')).toHaveValue(v.capacityDrop);
      expect(view.$('#congestion_speed')).toHaveValue(v.congestionSpeed);
      expect(view.$('#std_dev_capacity')).toHaveValue(v.capacityStandardDev);
      expect(view.$('#std_dev_congestion')).toHaveValue(v.congestionStandardDev);
      expect(view.$('#std_dev_free_flow_speed')).toHaveValue(v.freeFlowStdDev);
      expect(view.$('#cp_text')).toHaveValue(v.capacityProfile);
      //expect(view.$('#dp_text')).toHaveValue(v.demandProfile);
      expect(view.$('#knob')).toHaveValue(v.knob);
      // expect(view.$('#link_demand_start_hour')).toHaveValue(v.dpStart.h);
      //       expect(view.$('#link_demand_start_minute')).toHaveValue(v.dpStart.m);
      //       expect(view.$('#link_demand_start_second')).toHaveValue(v.dpStart.s);
      // expect(view.$('#link_demand_sample_hour')).toHaveValue(v.dpSample.h);
      //       expect(view.$('#link_demand_sample_minute')).toHaveValue(v.dpSample.m);
      expect(view.$('#link_capacity_sample_second')).toHaveValue(v.cpSample.s);
      expect(view.$('#link_capacity_start_hour')).toHaveValue(v.cpStart.h);
      expect(view.$('#link_capacity_start_minute')).toHaveValue(v.cpStart.m);
      expect(view.$('#link_capacity_start_second')).toHaveValue(v.cpStart.s);
      expect(view.$('#link_capacity_sample_hour')).toHaveValue(v.cpSample.h);
      expect(view.$('#link_capacity_sample_minute')).toHaveValue(v.cpSample.m);
      expect(view.$('#link_capacity_sample_second')).toHaveValue(v.cpSample.s);
    });
  });
  
   describe("Events", function() {  
     beforeEach(function() {
        this.view.render();
        $(this.view.el).find(":input").prop("disabled", false)

    });

      describe("When fields handler fired", function() {
             it("Link Tab: 'Name' field calls save", function() {
                   $('#link_name').blur();
                   expect($a.EditorLinkView.prototype.saveName).toHaveBeenCalled();
                 });
             it("Link Tab: 'Type' field calls save", function() {
               $('#link_type').blur();
               expect($a.EditorLinkView.prototype.saveType).toHaveBeenCalled();
             });
            // TODO : FIX THIS -- The projection for the map is not loaded at 
            //  the time of save
            //  it("Geo Tab: 'Lanes' field calls save", function() { 
            //     $('#lanes').blur();
            //     expect($a.EditorLinkView.prototype.save).toHaveBeenCalled();
            //   });
            //    it("Geo Tab: 'Lanes Offset' field calls save", function() { 
            //     $('#lane_offset').blur();
            //     expect($a.EditorLinkView.prototype.save).toHaveBeenCalled();
            //   });
            //   it("Geo Tab: 'Length' field calls save", function() {
            //     $('#length').blur();
            //     expect($a.EditorLinkView.prototype.save).toHaveBeenCalled();
            // });
 /*            it("FD Tab: 'Free Flow Speed' field calls saveFD", function() {
                   $('#free_flow_speed').blur();
                   expect($a.EditorLinkView.prototype.saveFD).toHaveBeenCalled();
                 });
                 it("FD Tab: 'Congestion Speed' field calls saveFD", function() {
                   $('#congestion_speed').blur();
                   expect($a.EditorLinkView.prototype.saveFD).toHaveBeenCalled();
                 });
                 it("FD Tab: 'Critical Speed' field calls saveFD", function() { 
                   $('#critical_speed').blur();
                   expect($a.EditorLinkView.prototype.saveFD).toHaveBeenCalled();
                 });
                 it("FD Tab: 'Capacity' field calls saveFD", function() { 
                   $('#capacity').blur();
                   expect($a.EditorLinkView.prototype.saveFD).toHaveBeenCalled();
                 });
                 it("FD Tab: 'Capacity Drop' field calls saveFD", function() {
                   $('#capacity_drop').blur();
                   expect($a.EditorLinkView.prototype.saveFD).toHaveBeenCalled();
                 });
                 it("FD Tab: 'Standard Deviation Capacity' field calls saveFD", function() {
                   $('#std_dev_capacity').blur();
                   expect($a.EditorLinkView.prototype.saveFD).toHaveBeenCalled();
                 });
                 it("FD Tab: 'Standard Deviation Congestion' field calls saveFD", function() { 
                   $('#std_dev_congestion').blur();
                   expect($a.EditorLinkView.prototype.saveFD).toHaveBeenCalled();
                 });
                 it("FD Tab: 'Standard Deviation Free Flow Speed' field calls saveFD", function() { 
                   $('#std_dev_free_flow_speed').blur();
                   expect($a.EditorLinkView.prototype.saveFD).toHaveBeenCalled();
                 });
                 it("Demand Tab: 'Knob' field calls saveDP", function() {
                   $('#knob').blur();
                   expect($a.EditorLinkView.prototype.saveDP).toHaveBeenCalled();
                 });
                 // Text area no longer in use (data tables instead)
                 //it("Demand Tab: 'Demand Profile' field calls saveDP", function() {
                 //  $('#dp_text').blur();
                 //  expect($a.EditorLinkView.prototype.saveDP).toHaveBeenCalled();
                 //});
                 it("Demand Tab: 'Start Time: hour' field calls saveDPTime", function() {
                   $('#link_demand_start_hour').blur();
                   expect($a.EditorLinkView.prototype.saveDPTime).toHaveBeenCalled();
                 });
                 it("Demand Tab: 'Start Time: minute' field calls saveDPTime", function() {
                   $('#link_demand_start_minute').blur();
                   expect($a.EditorLinkView.prototype.saveDPTime).toHaveBeenCalled();
                 });
                 it("Demand Tab: 'Start Time: second' field calls saveDPTime", function() { 
                   $('#link_demand_start_second').blur();
                   expect($a.EditorLinkView.prototype.saveDPTime).toHaveBeenCalled();
                 });
                 it("Demand Tab: 'Sampling Period: hour' field calls saveDPTime", function() {
                   $('#link_demand_sample_hour').blur();
                   expect($a.EditorLinkView.prototype.saveDPTime).toHaveBeenCalled();
                 });
                 it("Demand Tab: 'Sampling Period: minute' field calls saveDPTime", function() {
                   $('#link_demand_sample_minute').blur();
                   expect($a.EditorLinkView.prototype.saveDPTime).toHaveBeenCalled();
                 });
                 it("Demand Tab: 'Sampling Period: second' field calls saveDPTime", function() { 
                   $('#link_demand_sample_second').blur();
                   expect($a.EditorLinkView.prototype.saveDPTime).toHaveBeenCalled();
                 });     */
                 it("Capacity Tab: 'Capacity Profile' field calls saveCP", function() { 
                   $('#cp_text').blur();
                   expect($a.EditorLinkView.prototype.saveCP).toHaveBeenCalled();
                 });
                 it("Capacity Tab: 'Start Time: hour' field calls saveCPTime", function() { 
                    $('#link_capacity_start_hour').blur();
                   expect($a.EditorLinkView.prototype.saveCPTime).toHaveBeenCalled();
                 });
                 it("Capacity Tab: 'Start Time: minute' field calls saveCPTime", function() { 
                   $('#link_capacity_start_minute').blur();
                   expect($a.EditorLinkView.prototype.saveCPTime).toHaveBeenCalled();
                 });
                 it("Capacity Tab: 'Start Time: second' field calls saveCPTime", function() { 
                   $('#link_capacity_start_second').blur();
                   expect($a.EditorLinkView.prototype.saveCPTime).toHaveBeenCalled();
                 });
                 it("Capacity Tab: 'Sampling Period: hour' field calls saveCPTime", function() { 
                   $('#link_capacity_sample_hour').blur();
                   expect($a.EditorLinkView.prototype.saveCPTime).toHaveBeenCalled();
                 });
                 it("Capacity Tab: 'Sampling Period: minute' field calls saveCPTime", function() { 
                   $('#link_capacity_sample_minute').blur();
                   expect($a.EditorLinkView.prototype.saveCPTime).toHaveBeenCalled();
                 });
                 it("Capacity Tab: 'Sampling Period: second' field calls saveCPTime", function() { 
                   $('#link_capacity_sample_second').blur();
                   expect($a.EditorLinkView.prototype.saveCPTime).toHaveBeenCalled();
                 });
               });
         describe("When the In Sync click handler fired", function() {
            it("in_sync is saved", function() { 
              $('#in_sync').attr('checked', 'checked'); 
              $('#in_sync').click();
              expect(this.view.models[0].get('in_sync')).toBeTruthy();
            });
         });
         
        describe("When buttons clicked handler fired", function() {
              beforeEach(function() {
                $(this.view.el).find(":input").prop("disabled", false)
                $(this.view.el).find(":button").prop("disabled", false)
              });
              it("'Sub Divide Now' button calls subDivide", function() { 
                  $('#do-subdivide').click();
                  expect($a.EditorLinkView.prototype.subDivide).toHaveBeenCalled();
                });
                it("'Split Now' button calls doSplit", function() { 
                  $('#do-split').click();
                  expect($a.EditorLinkView.prototype.doSplit).toHaveBeenCalled();
                });
                it("'Add Left Turn' button calls addLeftTurn", function() { 
                  $('#add-lt').click();
                  expect($a.EditorLinkView.prototype.addLeftTurn).toHaveBeenCalled();
                });
                it("'Add Right Turn' button calls addRightTurn", function() { 
                  $('#add-rt').click();
                  expect($a.EditorLinkView.prototype.addRightTurn).toHaveBeenCalled();
                });
                it("'Add Right Turn' button calls addRightTurn", function() { 
                  $('#add-rt').click();
                  expect($a.EditorLinkView.prototype.addRightTurn).toHaveBeenCalled();
                });
                it("'Choose Name' button calls chooseName", function() { 
                  $('#choose-name').click();
                  expect($a.EditorLinkView.prototype.chooseName).toHaveBeenCalled();
                });
                it("'Reverse Link' button calls reverseLink", function() { 
                  $('#reverse-link').click();
                  expect($a.EditorLinkView.prototype.reverseLink).toHaveBeenCalled();
                });
              it("'Set Geometry to Line' button calls geomLine", function() { 
                 $('#geom-line').click();
                 expect($a.EditorLinkView.prototype.geomLine).toHaveBeenCalled();
               });
               it("'Set Geometry to Roads' button calls geomRoad", function() { 
                 $('#geom-road').click();
                 expect($a.EditorLinkView.prototype.geomRoad).toHaveBeenCalled();
               });
             });
                  
             describe("When fields handlers fired their information is saved", function() {
              beforeEach(function() {
                $(this.view.el).find(":input").prop("disabled", false)
              });
              // _.each(testsLinkGeo, function(test) { 
              //              it(test.desc, function() {
              //                googleMap();
              //                $(test.id).val(test.val);
              //                $(test.id).blur();
              //                expect(this.view.models[0].get(test.field)).toEqual(test.val);
              //              });
              //            });
              it("Link Tab: 'Name' is saved", function() {
                    $a.broker.trigger('map:open_network_mode');
                    $("#link_name").val("changed");
                    $("#link_name").blur();      
                    expect(this.view.models[0].link_name()).toEqual("changed");
              });
               it("Link Tab: 'Type' is saved", function() {
                 selected = $($(this.view.el)).find('#link_name option:selected')
                 $(selected).attr('selected', false);
                 options = $(this.view.el).find("select option");
                 $(options[1]).attr('selected', true);
                 newSelectedValue = $(options[1]).attr("name");
                 $("#link_type").blur();
                 expect(this.view.models[0].link_type().name()).toEqual(newSelectedValue);
                });
  /*             _.each(testsFD, function(test) {
                 it(test.desc, function() {
                   $(test.id).val(test.val);
                   $(test.id).blur();
                   fdp = this.view.models[0].get('fundamentaldiagramprofile');
                   fd = fdp.get('fundamentaldiagram')[0];
                   expect(fd.get(test.field)).toEqual(test.val);
                 });
               });
              _.each(testsDemand, function(test) {
                 it(test.desc, function() {
                   $(test.id).val(test.val);
                   $(test.id).blur();
                   dp = this.view.models[0].get('demand');
                   expect(dp.get(test.field)).toEqual(test.val);
                 });
               });   */
               _.each(testsCapacity, function(test) { 
                 it(test.desc, function() {
                   $(test.id).val(test.val);
                   $(test.id).blur();
                   cp = this.view.models[0].get('capacity');
                   if(cp !== undefined)
                    expect(cp.get(test.field)).toEqual(test.val);
                  });
               });
/*               it("Demand Tab: Start Time is saved", function() {
                 $("#link_demand_start_hour").val(1);
                 $("#link_demand_start_minute").val(1);
                 $("#link_demand_start_second").val(1);
                 $("#link_demand_start_hour").blur();
                 dp = this.view.models[0].get('demand');
                 expect(dp.get("start_time")).toEqual(3661);
               });
              it("Demand Tab: Sampling Period is saved", function() {
                $("#link_demand_sample_hour").val(1);
                $("#link_demand_sample_minute").val(1);
                $("#link_demand_sample_second").val(1);
                $("#link_demand_sample_hour").blur();
                dp = this.view.models[0].get('demand');
                expect(dp.get("dt")).toEqual(3661);
              });  */
              it("Capacity Tab: Start Time is saved", function() {
                $("#link_capacity_start_hour").val(1);
                $("#link_capacity_start_minute").val(1);
                $("#link_capacity_start_second").val(1);
                $("#link_capacity_start_hour").blur();
                cp = this.view.models[0].get('capacity');
                if(cp !== undefined)
                 expect(cp.get("start_time")).toEqual(3661);
              });
              it("Capacity Tab: Sampling Period is saved", function() {
                $("#link_capacity_sample_hour").val(1);
                $("#link_capacity_sample_minute").val(1);
                $("#link_capacity_sample_second").val(1);
                $("#link_capacity_sample_hour").blur();
                cp = this.view.models[0].get('capacity');
                if(cp !== undefined)
                 expect(cp.get("dt")).toEqual(3661);
              });
     });
   });
});