###
 * Copyright (c) 2011, iSENSE Project. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer. Redistributions in binary
 * form must reproduce the above copyright notice, this list of conditions and
 * the following disclaimer in the documentation and/or other materials
 * provided with the distribution. Neither the name of the University of
 * Massachusetts Lowell nor the names of its contributors may be used to
 * endorse or promote products derived from this software without specific
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 *
###
$ ->
  if namespace.controller is "visualizations" and namespace.action in ["displayVis", "embedVis", "show"]
      
    class window.Motion extends BaseVis
        constructor: (@canvas) -> 

        start: ->
            #Make table visible? (or somthing)
            ($ '#' + @canvas).show()
            
            @hideControls()
            
            dt = new google.visualization.DataTable();
            
            #Generate a list of fieldIndexes (incase we need to shuffle)
            fieldIndexes = for field,fieldIndex in data.fields
                fieldIndex
            
            
            fieldIndexes[0] = data.groupingFieldIndex
            fieldIndexes[data.groupingFieldIndex] = 0;
            
            # Check to see if we should shuffle a time field to the front. 
            if ( data.timeFields.length > 0 )
                if ( data.timeFields[0] != 1)
                    tmp = fieldIndexes[1];
                    fieldIndexes[1] = data.timeFields[0]
                    fieldIndexes[data.timeFields[0]] = tmp       
                    
            for i in fieldIndexes
                field = data.fields[i]
                switch (Number field.typeID)
                    when data.types.TEXT then dt.addColumn('string', field.fieldName) 
                    when data.types.TIME then dt.addColumn('date', field.fieldName)
                    else dt.addColumn('number', field.fieldName)

            rows = for dataPoint in data.dataPoints
                line = for i in fieldIndexes
                    dat = dataPoint[i]              
                    datType = (Number data.fields[i].typeID)
                    if(datType is data.types.TIME)
                        new Date(dat)
                    else 
                        dat
                line
    
            dt.addRow(row) for row in rows
            
            chart = new google.visualization.MotionChart(document.getElementById('motion_canvas'));
            chart.draw(dt, {width: '100%', height: '100%'});
            super()

        #Gets called when the controls are clicked and at start
        update: ->
            super()
            
        end: ->
            ($ '#' + @canvas).hide()
            @unhideControls()
            
        drawControls: ->
            super()

        drawChart: ->

    if "Motion" in data.relVis
        globals.motion = new Motion "motion_canvas"      
    else
        globals.motion = new DisabledVis "motion_canvas"
