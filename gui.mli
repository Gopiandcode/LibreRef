(*
    LibreRef is a free as in freedom digital referencing tool for artists.
    Copyright (C) <2021>  <Kiran Gopinathan>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.

Also add information on how to contact you by electronic and paper mail.

  If your software can interact with users remotely through a computer
network, you should also make sure that it provides a way for users to
get its source.  For example, if your program is a web application, its
interface could display a "Source" link that leads users to an archive
of the code.  There are many ways you could offer source, and different
solutions will be better for different programs; see section 13 for the
specific requirements.

  You should also get your employer (if you work as a programmer) or school,
if any, to sign a "copyright disclaimer" for the program, if necessary.
For more information on this, and how to apply and follow the GNU AGPL, see
<https://www.gnu.org/licenses/>.
*)

(** RUNTIME_CONTEXT encodes the core GTK elements used to run the application   *)
module type RUNTIME_CONTEXT = sig

  (** Window of main application *)
  val w : GWindow.window

  (** Primary drawing area for application *)
  val d : GMisc.drawing_area

end

(** LOGIC captures the interface between the UI and the Logic of the application *)
module type LOGIC = sig

  (** [clear_scene ()] resets the application's stored scene to an empty scene   *)
  val clear_scene : unit -> unit

  (** [is_scene_dirty ()] returns true if the application's stored scene has had changes  *)
  val is_scene_dirty : unit -> bool

  (** [current_scene_name ()] returns the filename corresponding to
     the current file if it exists. *)
  val current_scene_name : unit -> string option


  (** [get_title ()] returns the title corresponding to the current application state *)
  val get_title: unit -> string

  (** [add_files_to_scene (x,y) files] loads each file in files and
     inserts the image at position (x,y) and returns the list of
     errors encountered while loading the images.

      Note: (x,y) are in screen coordinates not world coordinates.  *)
  val add_files_to_scene : float * float -> string list -> string list

  (** [open_scene_from_file filename] updates the application's stored
     scene to the scene contained in the file at filename, returning
     the list of errors encountered while loading the scene. *)
  val open_scene_from_file : string -> string list

  (** [save_scene_as filename] saves the current stored scene to the
     file at filename, returning the list of errors encountered while
     loading the scene *)
  val save_scene_as : string -> string list

end

module type DIALOG = sig

  (** [handle_quit_application ()] quits the application. If there are
     unsaved changes to the current scene, then it asks the user
     whether these changes should be saved *)
  val handle_quit_application : unit -> unit

  (** [show_right_click_menu button] pops up a menu at the position of
     the cursor *)
  val show_right_click_menu : GdkEvent.Button.t -> unit

  (** [show_errors errors] pops up a dialog box listing all errors *)
  val show_errors : string list -> unit

end

module type UI = sig
  (** Called by GTK to paint the drawing area. *)
  val expose : Cairo.context -> bool

  (** Handle motion events.  *)
  val on_move : GdkEvent.Motion.t -> bool

  (** Handle mouse button release events.  *)
  val on_button_release : GdkEvent.Button.t -> bool

  (** Handle mouse button press events.  *)
  val on_button_press : GdkEvent.Button.t -> bool

  (** Handle scroll events. *)
  val on_scroll : GdkEvent.Scroll.t -> bool
end

module Make : functor
  (Logic : LOGIC)
  (BuildUI : functor (R : RUNTIME_CONTEXT) (D : DIALOG) -> UI) -> sig

  (** Run the libreref GUI *)
  val main : unit -> unit

end