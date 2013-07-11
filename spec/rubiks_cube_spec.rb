require './lib/rubiks_cube'

describe Rubiks_Cube do
    describe "#factory_solved_cube" do
        it "should make correctly arranged factory solved cube" do
            cube = Rubiks_Cube.factory_solved_cube
            cube.faces[:FRONT_FACE].should eq [ [:green, :green, :green],
                                                [:green, :green, :green],
                                                [:green, :green, :green] ]
            cube.faces[:RIGHT_FACE].should eq [ [:red, :red, :red],
                                                [:red, :red, :red],
                                                [:red, :red, :red] ]
            cube.faces[:LEFT_FACE].should eq  [ [:orange, :orange, :orange],
                                                [:orange, :orange, :orange],
                                                [:orange, :orange, :orange] ]
            cube.faces[:BACK_FACE].should eq [ [:yellow, :yellow, :yellow],
                                               [:yellow, :yellow, :yellow],
                                               [:yellow, :yellow, :yellow] ]
            cube.faces[:TOP_FACE].should eq [ [:white, :white, :white],
                                              [:white, :white, :white],
                                              [:white, :white, :white] ]
            cube.faces[:BOTTOM_FACE].should eq [ [:blue, :blue, :blue],
                                               [:blue, :blue, :blue],
                                               [:blue, :blue, :blue] ]
        end

        it "should recognise factory solved cubes as identical" do
            Rubiks_Cube.factory_solved_cube.should eq Rubiks_Cube.factory_solved_cube
        end
    end

    describe "#twist" do
        context "when twisting to the left" do
            def make_cube_with_right_twisted_slice slice_id
                cube = Rubiks_Cube.factory_solved_cube
                cube.faces[:FRONT_FACE].set_slice slice_id, [:orange, :orange, :orange]
                cube.faces[:RIGHT_FACE].set_slice slice_id, [:green, :green, :green]
                cube.faces[:LEFT_FACE].set_slice slice_id, [:yellow, :yellow, :yellow]
                cube.faces[:BACK_FACE].set_slice slice_id, [:red, :red, :red]
                cube
            end

            [:TOP_ROW, :MIDDLE_ROW, :BOTTOM_ROW].each do |slice|
                it "twists front face for #{slice} correctly" do
                    cube = make_cube_with_right_twisted_slice slice
                    cube.twist( { :face => :FRONT_FACE, :slice => slice, :direction => :LEFT} )
                    cube.should eq Rubiks_Cube.factory_solved_cube
                end
            end
        end

        context "when twisting to the right" do
            def make_cube_with_left_twisted_slice slice_id
                cube = Rubiks_Cube.factory_solved_cube
                cube.faces[:FRONT_FACE].set_slice slice_id, [:red, :red, :red]
                cube.faces[:RIGHT_FACE].set_slice slice_id, [:yellow, :yellow, :yellow]
                cube.faces[:LEFT_FACE].set_slice slice_id, [:green, :green, :green]
                cube.faces[:BACK_FACE].set_slice slice_id, [:orange, :orange, :orange]
                cube
            end

            [:TOP_ROW, :MIDDLE_ROW, :BOTTOM_ROW].each do |slice|
                it "twists front face for #{slice} correctly" do
                    cube = make_cube_with_left_twisted_slice slice
                    cube.twist( { :face => :FRONT_FACE, :slice => slice, :direction => :RIGHT} )
                    cube.should eq Rubiks_Cube.factory_solved_cube
                end
            end
        end
    end

    describe "#find_steps_to_solve" do
        it "should take no steps to solve an already solved cube" do
            cube = Rubiks_Cube.factory_solved_cube
            cube.find_steps_to_solve.should eq([])
        end

        it "should take one step to solve a preset cube rotated once to the left" do
            cube = Rubiks_Cube.factory_solved_cube
            cube.faces[:FRONT_FACE].set_slice :TOP_ROW, [:red, :red, :red]
            cube.faces[:RIGHT_FACE].set_slice :TOP_ROW, [:yellow, :yellow, :yellow]
            cube.faces[:LEFT_FACE].set_slice :TOP_ROW, [:green, :green, :green]
            cube.faces[:BACK_FACE].set_slice :TOP_ROW, [:orange, :orange, :orange]

            cube.find_steps_to_solve.should eq( [
                { :face => :FRONT_FACE, :slice => :TOP_ROW, :direction => :RIGHT}
                ] )
        end

        it "should take one step to solve a preset cube rotated once to the right" do
            cube = Rubiks_Cube.factory_solved_cube
            cube.faces[:FRONT_FACE].set_slice :TOP_ROW, [:orange, :orange, :orange]
            cube.faces[:RIGHT_FACE].set_slice :TOP_ROW, [:green, :green, :green]
            cube.faces[:LEFT_FACE].set_slice :TOP_ROW, [:yellow, :yellow, :yellow]
            cube.faces[:BACK_FACE].set_slice :TOP_ROW, [:red, :red, :red]

            cube.find_steps_to_solve.should eq( [
                { :face => :FRONT_FACE, :slice => :TOP_ROW, :direction => :LEFT}
                ] )
        end
    end
end
