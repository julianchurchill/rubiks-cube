
class Array
    def set_slice slice_id, slice
        self[ index_to_slice[slice_id] ] = slice
    end

    def slice slice_id
        self[ index_to_slice[slice_id] ]
    end

    def index_to_slice
        {:TOP_ROW => 0, :MIDDLE_ROW => 1, :BOTTOM_ROW => 2}
    end
end

class Rubiks_Cube
    attr_reader :faces, :twists

    def self.factory_solved_cube
        cube = Rubiks_Cube.new
        cube.set_face( :FRONT_FACE,  [ [:green, :green, :green],
                                       [:green, :green, :green],
                                       [:green, :green, :green] ] )
        cube.set_face( :RIGHT_FACE,  [ [:red, :red, :red],
                                       [:red, :red, :red],
                                       [:red, :red, :red] ] )
        cube.set_face( :LEFT_FACE,  [ [:orange, :orange, :orange],
                                      [:orange, :orange, :orange],
                                      [:orange, :orange, :orange] ] )
        cube.set_face( :BACK_FACE, [ [:yellow, :yellow, :yellow],
                                     [:yellow, :yellow, :yellow],
                                     [:yellow, :yellow, :yellow] ] )
        cube.set_face( :TOP_FACE, [ [:white, :white, :white],
                                    [:white, :white, :white],
                                    [:white, :white, :white] ] )
        cube.set_face( :BOTTOM_FACE, [ [:blue, :blue, :blue],
                                       [:blue, :blue, :blue],
                                       [:blue, :blue, :blue] ] )
        cube
    end

    def initialize( twists = nil, faces = nil )
        @twists = twists
        @faces = faces
        @twists ||= []
        @faces ||= {}
    end

    def face_to_the_right_of
        {:FRONT_FACE => :RIGHT_FACE, :LEFT_FACE => :FRONT_FACE, :BACK_FACE => :LEFT_FACE, :RIGHT_FACE => :BACK_FACE }
    end

    def face_to_the_left_of
        {:FRONT_FACE => :LEFT_FACE, :LEFT_FACE => :BACK_FACE, :BACK_FACE => :RIGHT_FACE, :RIGHT_FACE => :FRONT_FACE }
    end

    def next_face_generators
        {:RIGHT => face_to_the_left_of, :LEFT => face_to_the_right_of }
    end

    def clone
        # When faces is its own class (not Array), put Marshal in Faces.clone()
        Rubiks_Cube.new( self.twists.clone, Marshal.load( Marshal.dump(self.faces) ) )
    end

    def ==(other)
        self.faces == other.faces
    end

    def set_face face_key, face_content
        @faces[face_key] = face_content
    end

    def twist params
        rotate_slice_for_each_face( params[:slice],
                                  next_face_generators[params[:direction]],
                                  params[:face] )
    end

    def rotate_slice_for_each_face slice_id, next_face_generator, first_face
        ordered_faces = generate_ordered_faces( next_face_generator, first_face )
        saved_slice = @faces[ordered_faces.first].slice( slice_id )
        ordered_faces.each do |face|
            if face == ordered_faces.last
                @faces[face].set_slice( slice_id, saved_slice )
            else
                @faces[face].set_slice( slice_id, @faces[next_face_generator[face]].slice( slice_id ) )
            end
        end
    end

    def generate_ordered_faces next_face_generator, first_face
        faces = []
        next_face = first_face
        loop do
            faces += [next_face_generator[next_face]]
            next_face = next_face_generator[next_face]
            break if next_face == first_face
        end
        return faces
    end

    def solves_cube? solution
        test_cube = clone()
        solution.each { |t| test_cube.twist( t ) }
        return test_cube == Rubiks_Cube.factory_solved_cube
    end

    def find_steps_to_solve
        return [] if self == Rubiks_Cube.factory_solved_cube

        proposed_solution = [{ :face => :FRONT_FACE, :slice => :TOP_ROW, :direction => :RIGHT}]
        return proposed_solution if solves_cube? proposed_solution
        proposed_solution = [{ :face => :FRONT_FACE, :slice => :TOP_ROW, :direction => :LEFT}]
        return proposed_solution if solves_cube? proposed_solution

        return [ :error ]
    end
end
