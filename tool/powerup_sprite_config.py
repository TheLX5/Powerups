import tkinter as tk
import tkinter.tix as tix
from tkinter import ttk
from tkinter import filedialog
from tkinter import messagebox
from tkinter.messagebox import showerror
import webbrowser
import os
import json
import base64

icon = "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"

class Toolbar(tk.Frame):
	def __init__(self, master):
		self.master = master
		
		self.powerup_specific_defs = []
		self.powerup_list_options = []
			
		self.frame = tk.Frame(self.master)
		self.menubar = tk.Menu(self.frame)
		
		self.filemenu = tk.Menu(self.menubar, tearoff=0)
		self.filemenu.add_command(label="Open", command=self.file_open)
		self.filemenu.add_command(label="Save changes to files", command=self.file_save)
		self.filemenu.entryconfig(1, state="disabled")
		self.filemenu.add_separator()
		self.filemenu.add_command(label="Close", command=root.destroy)
		self.menubar.add_cascade(label="File", menu=self.filemenu)
		
		self.aboutmenu = tk.Menu(self.menubar, tearoff=0)
		self.aboutmenu.add_command(label="Custom Powerups Wiki", command=self.about_wiki)
		self.menubar.add_cascade(label="About", menu=self.aboutmenu)
		
		self.master.config(menu=self.menubar)
                
	def file_open(self):
		global current_sprite
		self.powerups_defs_path = tk.filedialog.askopenfilename(
								  initialdir="./",
								  title="Open powerup_defs.asm",
								  filetypes=(("Custom Powerups configuration file","powerup_defs.asm"),("All files","*.*")))
		if self.powerups_defs_path:
			try:
				with open(self.powerups_defs_path, "r") as f:
					file = f.read()
					if ";I hope you did read the readme." not in file:
						tk.messagebox.showerror("Open powerup_defs.asm", "This isn't a valid powerup_defs.asm file!")
						return
				self.powerup_files_path = self.powerups_defs_path[:self.powerups_defs_path.rfind("/")+1]
				if not(os.path.isdir(self.powerup_files_path+"powerups_files/powerup_interaction_code")):
					tk.messagebox.showerror("Open powerup_defs.asm", "This isn't the powerup_defs.asm file you should open.\n\nSelect the one that is in the same folder as powerup.asm.")
					return
			except Exception as e:
				tk.messagebox.showerror("Open powerup_defs.asm", "Failed to read powerup_defs.asm file.")
				return
		else:
			tk.messagebox.showerror("Open powerup_defs.asm", "No file was providen.")
			return
				
		self.pixi_list_path = tk.filedialog.askopenfilename(
							  initialdir="./",
							  title="Open PIXI sprite list.txt",
							  filetypes=(("PIXI sprite list","*.txt"),("All files","*.*")))
		if self.pixi_list_path:
			try:
				with open(self.pixi_list_path, "r") as f:
					file = f.read()
					if "EXTENDED" not in file:
						tk.messagebox.showerror("Open PIXI sprite list", "This isn't a valid PIXI sprite list file.")
						return
					self.pixi_path = self.pixi_list_path[:self.pixi_list_path.rfind("/")+1]
					if not(os.path.isdir(self.pixi_path+"/extended/powerup/")):
						tk.messagebox.showerror("Open PIXI sprite list", "Can't find the settings files of the projectiles.\n\nBe sure that PIXI's sprite list exists in the same folder as the extended sprites folder.")
						return
					with open(self.pixi_path+"/extended/powerup/mario_hammer_props.asm") as h:
						if "; custom sprites FC-FF" in file:
							tk.messagebox.showerror("Open PIXI sprite list", "Please update to a newer version of the Custom Powerups patch.")
							return
					if not(os.path.isfile(self.pixi_path+"/extended/powerup/mario_elecball_props.asm")):
						tk.messagebox.showerror("Open PIXI sprite list", "Please update to a newer version of the Custom Powerups patch.")
						return
			except Exception as e:
				tk.messagebox.showerror("Open PIXI sprite list", "Failed to read PIXI sprite list.")
				return
		else:
			tk.messagebox.showerror("Open PIXI sprite list", "No file was providen.")
			return
			
		self.filemenu.entryconfig(1, state="normal")
		
		self.load_files = [self.pixi_path+"extended/powerup/mario_hammer_props.asm",
						   self.pixi_path+"/extended/powerup/mario_boomerang_props.asm",
						   self.pixi_path+"/extended/powerup/mario_iceball_props.asm",
						   self.pixi_path+"/extended/powerup/mario_superball_props.asm",
						   self.pixi_path+"/extended/powerup/mario_bubble_props.asm",
						   self.pixi_path+"/extended/powerup/mario_elecball_props.asm",
						   self.powerup_files_path+"powerups_files/powerup_interaction_code/tanooki_table.asm",
						   self.powerup_files_path+"powerups_files/powerup_interaction_code/mini_table.asm",
						   self.powerup_files_path+"powerups_files/powerup_interaction_code/shell_suit_table.asm",
						   self.powerup_files_path+"powerups_files/powerup_interaction_code/cat_table.asm"]
					  
		self.compare = ["hammer_normal_sprites:",
						"boomerang_normal_sprites:",
						"iceball_normal_sprites:",
						"superball_normal_sprites:",
						"bubble_normal_sprites:",
						"elecball_normal_sprites:",
						"..normal_sprites_table",
						"..normal_sprites_table",
						"..normal_sprites_table",
						"..normal_sprites_table"]
		
		self.names = ["hammer",
					  "boomerang",
					  "iceball",
					  "superball",
					  "bubble",
					  "elecball",
					  "statue",
					  "mini",
					  "shell",
					  "cat"]
		
		for x in range(len(self.load_files)):
			with open(self.load_files[x], "r") as f:
				settings_file = f.readlines()
				i = 256
				for line in settings_file:
					line.rstrip('\r\n')
					try:
						if self.compare[x] in line:
							i = 0
							continue
						elif line[:3] == "db ":
							line = line[3:]
							if line[0] == "$":
								value = hex("0x"+line[1:3])
							elif line[0] == "%":
								value = int(line[1:9],2)
							else:
								continue
							if x == 0:
								sprite_names[i] = line[line.find(";"):][2:]
							settings[self.names[x]][i] = value
							i = i+1
					except:
						continue
		
		with open(self.pixi_path+"/list.txt", "r") as f:
			pixi_list = f.readlines()
			for line in pixi_list:
				if ("EXTENDED" or "CLUSTER") in line:
					break
				if len(line) > 2:
					try:
						num = int("0x"+line[:2], 16)
					except:
						pass
					filename = line[3:].split()[0]
					if filename[-5:] == ".json":
						with open(self.pixi_path+"sprites/"+filename, "r") as j:
							current_json = json.load(j)
							sprite_names[num+256] = sprite_names[num+256].split(":")[0] + ": " + str(current_json["Displays"][0]["Description"].split("\\n")[0])
					else:
						sprite_names[num+256] = sprite_names[num+256].split(":")[0] + ": " + line[3:]
				i = 0
		
		for child in self.master.winfo_children():
			if i == 0:
				i = i+1
				continue
			if not (isinstance(child, tk.Frame) or isinstance(child, tk.LabelFrame)):
				child.configure(state="normal")
				continue
			for child2 in child.winfo_children():
				if not (isinstance(child2, tk.Frame) or isinstance(child2, tk.LabelFrame)):
					child2.configure(state="normal")
					continue
				for child3 in child2.winfo_children():
					if not (isinstance(child3, tk.Frame) or isinstance(child3, tk.LabelFrame)):
						child3.configure(state="normal")
						if isinstance(child3, ttk.Combobox):
							child3.configure(state="readonly")
						continue
					for child4 in child3.winfo_children():
						if not (isinstance(child4, tk.Frame) or isinstance(child4, tk.LabelFrame)):
							child4.configure(state="normal")
							if isinstance(child4, ttk.Combobox):
								child4.configure(state="readonly")
							continue
						for child5 in child4.winfo_children():
							if not (isinstance(child5, tk.Frame) or isinstance(child5, tk.LabelFrame)):
								child5.configure(state="normal")
								if isinstance(child5, ttk.Combobox):
									child5.configure(state="readonly")
								continue
							for child6 in child5.winfo_children():
								if not (isinstance(child6, tk.Frame) or isinstance(child6, tk.LabelFrame)):
									child6.configure(state="normal")
									if isinstance(child6, ttk.Combobox):
										child6.configure(state="readonly")
										
		current_sprite = 0
		mainframe.sprite_list["values"] = sprite_names
		mainframe.sprite_list.current(0)
		mainframe.update_sprite_data()

	def file_save(self):
		for x in range(len(self.load_files)):
			with open(self.load_files[x], "r") as f:
				original_asm = f.readlines()
			i = 256
			with open(self.load_files[x], "w") as new_asm:
				for line in original_asm:
					if self.compare[x] in line:
						i = 0
					if line[:2] == "db":
						data = format(settings[self.names[x]][i],'#010b')
						line = "db %"+str(data)[2:]+"			; "+sprite_names[i]
						new_asm.write(line.replace('\r', '').replace('\n', '')+"\n")
						i = i+1
					else:
						new_asm.write(line)
					
		tk.messagebox.showinfo("Save changes to files", "Files sucessfully updated.\n\nPlease proceed to reinsert the main patch and PIXI sprites.")

	def about_wiki(self):
		self.website = "https://github.com/TheLX5/Powerups/wiki/1.-Main-Page"
		webbrowser.open(self.website,1)


class MainFrame(tk.Frame):
	def __init__(self, master):
		self.master = master
		
		self.main_frame_top = tk.Frame(master)
		self.main_frame_middle = tk.Frame(master)
		self.main_frame_bottom = tk.Frame(master)
		
		self.sprite_selector()
		
		self.middle_container_1 = tk.Frame(self.main_frame_middle)
		self.middle_container_2 = tk.Frame(self.main_frame_middle)
		self.middle_container_1.grid(row=0, column=0, sticky="nsew")
		self.middle_container_2.grid(row=0, column=1, sticky="nsew")
		self.main_frame_middle.grid_columnconfigure(0, weight=1, uniform="group1")
		self.main_frame_middle.grid_columnconfigure(1, weight=1, uniform="group1")
		self.main_frame_middle.grid_rowconfigure(0, weight=1)
		
		self.hammer_configuration(self.middle_container_1)
		self.superball_configuration(self.middle_container_1)
		self.iceball_configuration(self.middle_container_1)
		self.boomerang_configuration(self.middle_container_2)
		self.bubble_configuration(self.middle_container_2)
		self.elecball_configuration(self.middle_container_2)
		
		self.statue_configuration(self.middle_container_1)
		self.cat_configuration(self.middle_container_1)
		self.mini_configuration(self.middle_container_2)
		self.shell_configuration(self.middle_container_2)
		
		self.main_frame_top.pack(side="top", fill="x", padx=2, pady=2)
		self.main_frame_middle.pack(fill="both", padx=2, pady=2)
		self.main_frame_bottom.pack(fill="x", padx=2, pady=2)
		
		i = 0
		for child in self.master.winfo_children():
			if i == 0:
				i = i+1
				continue
			if not (isinstance(child, tk.Frame) or isinstance(child, tk.LabelFrame)):
				child.configure(state="disabled")
				continue
			for child2 in child.winfo_children():
				if not (isinstance(child2, tk.Frame) or isinstance(child2, tk.LabelFrame)):
					child2.configure(state="disabled")
					continue
				for child3 in child2.winfo_children():
					if not (isinstance(child3, tk.Frame) or isinstance(child3, tk.LabelFrame)):
						child3.configure(state="disabled")
						continue
					for child4 in child3.winfo_children():
						if not (isinstance(child4, tk.Frame) or isinstance(child4, tk.LabelFrame)):
							child4.configure(state="disabled")
							continue
						for child5 in child4.winfo_children():
							if not (isinstance(child5, tk.Frame) or isinstance(child5, tk.LabelFrame)):
								child5.configure(state="disabled")
								continue
							for child6 in child5.winfo_children():
								if not (isinstance(child6, tk.Frame) or isinstance(child6, tk.LabelFrame)):
									child6.configure(state="disabled")

########################################################

	def sprite_selector(self):
		self.sprite_selector_widget = tk.LabelFrame(self.main_frame_top, text="General", padx=5, pady=5)
		self.sprite_selector_widget.pack(fill="x", padx=3, pady=1)
		
		self.sprite_list_container = tk.Frame(self.sprite_selector_widget)
		self.sprite_list_container.pack(side=tk.LEFT)
		
		self.sprite_list_label = tk.Label(self.sprite_list_container , text="Sprite: ")
		self.sprite_list_label.pack(side=tk.LEFT)
		
		self.sprite_list = ttk.Combobox(self.sprite_list_container,
										state="readonly",
										height=20,
										width=50,
										values=sprite_names)
		self.sprite_list.bind("<<ComboboxSelected>>", self.selected_sprite)
		self.sprite_list.current(0)
		self.sprite_list.pack(side=tk.LEFT)
		
		self.sprite_save_button = ttk.Button(self.sprite_selector_widget, text="Save this sprite", width=25, command=self.save_sprite_data)
		self.sprite_save_button.pack()
	
	def selected_sprite(self, event):
		global current_sprite
		current_sprite = self.sprite_list.current()
		self.update_sprite_data()
		
	def hammer_configuration(self, main_widget):
		self.hammer_config_widget = tk.LabelFrame(main_widget, text="Hammer", padx=5, pady=5)
		self.hammer_config_widget.pack(fill="both", padx=3, pady=1)
		
		self.hammer_immunity_container = tk.Frame(self.hammer_config_widget)
		self.hammer_immunity_checkbox = tk.Checkbutton(self.hammer_immunity_container,
													   borderwidth=0,
													   variable=projectile_props["hammer_immunity"][0])
		self.hammer_immunity_checkbox.pack(side=tk.LEFT)
		self.hammer_immunity_label = tk.Label(self.hammer_immunity_container,text=projectile_props["hammer_immunity"][2])
		self.hammer_immunity_label.pack(side=tk.LEFT)
		
		self.hammer_disable_container = tk.Frame(self.hammer_config_widget)
		self.hammer_disable_checkbox = tk.Checkbutton(self.hammer_disable_container,
													  borderwidth=0,
													  variable=projectile_props["hammer_disable"][0])
		self.hammer_disable_checkbox.pack(side=tk.LEFT)
		self.hammer_disable_label = tk.Label(self.hammer_disable_container,text=projectile_props["hammer_disable"][2])
		self.hammer_disable_label.pack(side=tk.LEFT)
		
		self.hammer_immunity_container.pack(fill="x")
		self.hammer_disable_container.pack(fill="x")
		
	def boomerang_configuration(self, main_widget):
		self.boomerang_config_widget = tk.LabelFrame(main_widget, text="Boomerang", padx=5, pady=5)
		self.boomerang_config_widget.pack(fill="both", padx=3, pady=1)
		
		self.boomerang_immunity_container = tk.Frame(self.boomerang_config_widget)
		self.boomerang_immunity_checkbox = tk.Checkbutton(self.boomerang_immunity_container,
														  borderwidth=0,
														  variable=projectile_props["boomerang_immunity"][0])
		self.boomerang_immunity_checkbox.pack(side=tk.LEFT)
		self.boomerang_immunity_label = tk.Label(self.boomerang_immunity_container,text=projectile_props["boomerang_immunity"][2])
		self.boomerang_immunity_label.pack(side=tk.LEFT)
		
		self.boomerang_disable_container = tk.Frame(self.boomerang_config_widget)
		self.boomerang_disable_checkbox = tk.Checkbutton(self.boomerang_disable_container,
														 borderwidth=0,
														 variable=projectile_props["boomerang_disable"][0])
		self.boomerang_disable_checkbox.pack(side=tk.LEFT)
		self.boomerang_disable_label = tk.Label(self.boomerang_disable_container,text=projectile_props["boomerang_disable"][2])
		self.boomerang_disable_label.pack(side=tk.LEFT)

		self.boomerang_retrieve_container = tk.Frame(self.boomerang_config_widget)
		self.boomerang_retrieve_checkbox = tk.Checkbutton(self.boomerang_retrieve_container,
														  borderwidth=0,
														  onvalue=3,
														  offvalue=0,
														  variable=projectile_props["boomerang_retrieve"][0])
		self.boomerang_retrieve_checkbox.pack(side=tk.LEFT)
		self.boomerang_retrieve_label = tk.Label(self.boomerang_retrieve_container,text=projectile_props["boomerang_retrieve"][2])
		self.boomerang_retrieve_label.pack(side=tk.LEFT)
		
		self.boomerang_immunity_container.pack(fill="x")
		self.boomerang_disable_container.pack(fill="x")
		self.boomerang_retrieve_container.pack(fill="x")
		
	def iceball_configuration(self, main_widget):
		self.iceball_config_widget = tk.LabelFrame(main_widget, text="Iceball", padx=5, pady=5)
		self.iceball_config_widget.pack(fill="both", padx=3, pady=1)
		
		self.iceball_immunity_container = tk.Frame(self.iceball_config_widget)
		self.iceball_immunity_checkbox = tk.Checkbutton(self.iceball_immunity_container,
														borderwidth=0,
														variable=projectile_props["iceball_immunity"][0])
		self.iceball_immunity_checkbox.pack(side=tk.LEFT)
		self.iceball_immunity_label = tk.Label(self.iceball_immunity_container,text=projectile_props["iceball_immunity"][2])
		self.iceball_immunity_label.pack(side=tk.LEFT)
		
		self.iceball_disable_container = tk.Frame(self.iceball_config_widget)
		self.iceball_disable_checkbox = tk.Checkbutton(self.iceball_disable_container,
													   borderwidth=0,
													   variable=projectile_props["iceball_disable"][0])
		self.iceball_disable_checkbox.pack(side=tk.LEFT)
		self.iceball_disable_label = tk.Label(self.iceball_disable_container,text=projectile_props["iceball_disable"][2])
		self.iceball_disable_label.pack(side=tk.LEFT)
		
		self.iceball_smoke_container = tk.Frame(self.iceball_config_widget)
		self.iceball_smoke_checkbox = tk.Checkbutton(self.iceball_smoke_container,
													 borderwidth=0,
													 variable=projectile_props["iceball_smoke"][0])
		self.iceball_smoke_checkbox.pack(side=tk.LEFT)
		self.iceball_smoke_label = tk.Label(self.iceball_smoke_container,text=projectile_props["iceball_smoke"][2])
		self.iceball_smoke_label.pack(side=tk.LEFT)
		
		self.iceball_coin_container = tk.Frame(self.iceball_config_widget)
		self.iceball_coin_checkbox = tk.Checkbutton(self.iceball_coin_container,
													 borderwidth=0,
													 variable=projectile_props["iceball_coin"][0])
		self.iceball_coin_checkbox.pack(side=tk.LEFT)
		self.iceball_coin_label = tk.Label(self.iceball_coin_container,text=projectile_props["iceball_coin"][2])
		self.iceball_coin_label.pack(side=tk.LEFT)
			
		self.iceball_x_disp_container = tk.Frame(self.iceball_config_widget)
		self.iceball_x_disp_checkbox = tk.Checkbutton(self.iceball_x_disp_container,
													  borderwidth=0,
													  variable=projectile_props["iceball_x_disp"][0])
		self.iceball_x_disp_checkbox.pack(side=tk.LEFT)
		self.iceball_x_disp_label = tk.Label(self.iceball_x_disp_container,text=projectile_props["iceball_x_disp"][2])
		self.iceball_x_disp_label.pack(side=tk.LEFT)
		
		self.iceball_y_disp_container = tk.Frame(self.iceball_config_widget)
		self.iceball_y_disp_checkbox = tk.Checkbutton(self.iceball_y_disp_container,
													  borderwidth=0,
													  variable=projectile_props["iceball_y_disp"][0])
		self.iceball_y_disp_checkbox.pack(side=tk.LEFT)
		self.iceball_y_disp_label = tk.Label(self.iceball_y_disp_container,text=projectile_props["iceball_y_disp"][2])
		self.iceball_y_disp_label.pack(side=tk.LEFT)
		
		self.iceball_block_size_container = tk.Frame(self.iceball_config_widget)
		self.iceball_block_size_label = tk.Label(self.iceball_block_size_container,text=projectile_props["iceball_block_size"][2])
		self.iceball_block_size_label.pack(side=tk.LEFT)
		self.iceball_block_size_combo_box = ttk.Combobox(self.iceball_block_size_container,
														 state="readonly",
														 height=20,
														 width=8,
														 values=["16x16",
																 "16x32",
																 "32x16",
																 "32x32"])
		self.iceball_block_size_combo_box.bind("<<ComboboxSelected>>", self.selected_ice_block_size)
		self.iceball_block_size_combo_box.current(projectile_props["iceball_block_size"][0].get())
		self.iceball_block_size_combo_box.pack(side=tk.LEFT)
		
		self.iceball_immunity_container.pack(fill="x")
		self.iceball_disable_container.pack(fill="x")
		self.iceball_smoke_container.pack(fill="x")
		self.iceball_coin_container.pack(fill="x")
		self.iceball_block_size_container.pack(fill="x")
		self.iceball_x_disp_container.pack(fill="x")
		self.iceball_y_disp_container.pack(fill="x")
		
	def selected_ice_block_size(self, event):
		projectile_props["iceball_block_size"][0].set(self.iceball_block_size_combo_box.current())
		
	def superball_configuration(self, main_widget):
		self.superball_config_widget = tk.LabelFrame(main_widget, text="Superball", padx=5, pady=5)
		self.superball_config_widget.pack(fill="both", padx=3, pady=1)
		
		self.superball_immunity_container = tk.Frame(self.superball_config_widget)
		self.superball_immunity_checkbox = tk.Checkbutton(self.superball_immunity_container,
													  borderwidth=0,
													  variable=projectile_props["superball_immunity"][0])
		self.superball_immunity_checkbox.pack(side=tk.LEFT)
		self.superball_immunity_label = tk.Label(self.superball_immunity_container,text=projectile_props["superball_immunity"][2])
		self.superball_immunity_label.pack(side=tk.LEFT)
		
		self.superball_disable_container = tk.Frame(self.superball_config_widget)
		self.superball_disable_checkbox = tk.Checkbutton(self.superball_disable_container,
													  borderwidth=0,
													  variable=projectile_props["superball_disable"][0])
		self.superball_disable_checkbox.pack(side=tk.LEFT)
		self.superball_disable_label = tk.Label(self.superball_disable_container,text=projectile_props["superball_disable"][2])
		self.superball_disable_label.pack(side=tk.LEFT)
		
		self.superball_immunity_container.pack(fill="x")
		self.superball_disable_container.pack(fill="x")
		
	def bubble_configuration(self, main_widget):
		self.bubble_config_widget = tk.LabelFrame(main_widget, text="Bubble", padx=5, pady=5)
		self.bubble_config_widget.pack(fill="both", padx=3, pady=1)
		
		self.bubble_immunity_container = tk.Frame(self.bubble_config_widget)
		self.bubble_immunity_checkbox = tk.Checkbutton(self.bubble_immunity_container,
													  borderwidth=0,
													  variable=projectile_props["bubble_immunity"][0])
		self.bubble_immunity_checkbox.pack(side=tk.LEFT)
		self.bubble_immunity_label = tk.Label(self.bubble_immunity_container,text=projectile_props["bubble_immunity"][2])
		self.bubble_immunity_label.pack(side=tk.LEFT)
		
		self.bubble_disable_container = tk.Frame(self.bubble_config_widget)
		self.bubble_disable_checkbox = tk.Checkbutton(self.bubble_disable_container,
													  borderwidth=0,
													  variable=projectile_props["bubble_disable"][0])
		self.bubble_disable_checkbox.pack(side=tk.LEFT)
		self.bubble_disable_label = tk.Label(self.bubble_disable_container,text=projectile_props["bubble_disable"][2])
		self.bubble_disable_label.pack(side=tk.LEFT)
		
		self.bubble_immunity_container.pack(fill="x")
		self.bubble_disable_container.pack(fill="x")
		
	def elecball_configuration(self, main_widget):
		self.elecball_config_widget = tk.LabelFrame(main_widget, text="Elecball", padx=5, pady=5)
		self.elecball_config_widget.pack(fill="both", padx=3, pady=1)
		
		
		self.elecball_disable_container = tk.Frame(self.elecball_config_widget)
		self.elecball_disable_checkbox = tk.Checkbutton(self.elecball_disable_container,
														borderwidth=0,
														variable=projectile_props["elecball_disable"][0])
		self.elecball_disable_checkbox.pack(side=tk.LEFT)
		self.elecball_disable_label = tk.Label(self.elecball_disable_container,text=projectile_props["elecball_disable"][2])
		self.elecball_disable_label.pack(side=tk.LEFT)
		
		self.elecball_pierce_container = tk.Frame(self.elecball_config_widget)
		self.elecball_pierce_checkbox = tk.Checkbutton(self.elecball_pierce_container,
														borderwidth=0,
														variable=projectile_props["elecball_pierce"][0])
		self.elecball_pierce_checkbox.pack(side=tk.LEFT)
		self.elecball_pierce_label = tk.Label(self.elecball_pierce_container,text=projectile_props["elecball_pierce"][2])
		self.elecball_pierce_label.pack(side=tk.LEFT)
			
		self.elecball_paralyzed_container = tk.Frame(self.elecball_config_widget)
		self.elecball_paralyzed_checkbox = tk.Checkbutton(self.elecball_paralyzed_container,
														borderwidth=0,
														variable=projectile_props["elecball_paralyzed"][0])
		self.elecball_paralyzed_checkbox.pack(side=tk.LEFT)
		self.elecball_paralyzed_label = tk.Label(self.elecball_paralyzed_container,text=projectile_props["elecball_paralyzed"][2])
		self.elecball_paralyzed_label.pack(side=tk.LEFT)
		
		self.elecball_instakill_container = tk.Frame(self.elecball_config_widget)
		self.elecball_instakill_checkbox = tk.Checkbutton(self.elecball_instakill_container,
														borderwidth=0,
														variable=projectile_props["elecball_instakill"][0])
		self.elecball_instakill_checkbox.pack(side=tk.LEFT)
		self.elecball_instakill_label = tk.Label(self.elecball_instakill_container,text=projectile_props["elecball_instakill"][2])
		self.elecball_instakill_label.pack(side=tk.LEFT)
		
		self.elecball_fx_size_container = tk.Frame(self.elecball_config_widget)
		self.elecball_fx_size_label = tk.Label(self.elecball_fx_size_container,text=projectile_props["elecball_fx_size"][2])
		self.elecball_fx_size_label.pack(side=tk.LEFT)
		self.elecball_fx_size_combo_box = ttk.Combobox(self.elecball_fx_size_container,
														 state="readonly",
														 height=20,
														 width=30,
														 values=["16x16",
																 "32x32",
																 "16x32",
																 "16x32, shifted 16px up",
																 "32x16",
																 "48x16",
																 "64x16",
																 "80x16",
																 "64x64, shifted 8px left",
																 "64x64",
																 "16x16, shifted 8px up & left",
																 "Unused",
																 "Unused",
																 "Unused",
																 "Unused",
																 "Disappear in cloud of smoke",])
		self.elecball_fx_size_combo_box.bind("<<ComboboxSelected>>", self.selected_elec_fx_size)
		self.elecball_fx_size_combo_box.current(projectile_props["elecball_fx_size"][0].get())
		self.elecball_fx_size_combo_box.pack(side=tk.LEFT)
		
		self.elecball_note = tk.Label(self.elecball_config_widget,
									  text="NOTE: Enabling the last two options will bypass interaction with the elecballs, used for platforms",
									  wraplength=300,
									  justify=tk.LEFT)
		
		self.elecball_disable_container.pack(fill="x")
		self.elecball_pierce_container.pack(fill="x")
		self.elecball_fx_size_container.pack(fill="x")
		self.elecball_paralyzed_container.pack(fill="x")
		self.elecball_instakill_container.pack(fill="x")
		self.elecball_note.pack(side=tk.LEFT)
		
	def selected_elec_fx_size(self, event):
		projectile_props["elecball_fx_size"][0].set(self.elecball_fx_size_combo_box.current())
		

	def statue_configuration(self, main_widget):
		self.statue_config_widget = tk.LabelFrame(main_widget, text="Tanooki statue", padx=5, pady=5)
		self.statue_config_widget.pack(fill="both", padx=3, pady=1)
		
		self.statue_disable_container = tk.Frame(self.statue_config_widget)
		self.statue_disable_checkbox = tk.Checkbutton(self.statue_disable_container,
														borderwidth=0,
														variable=projectile_props["statue_disable"][0])
		self.statue_disable_checkbox.pack(side=tk.LEFT)
		self.statue_disable_label = tk.Label(self.statue_disable_container,text=projectile_props["statue_disable"][2])
		self.statue_disable_label.pack(side=tk.LEFT)
		
		self.statue_interact_container = tk.Frame(self.statue_config_widget)
		self.statue_interact_checkbox = tk.Checkbutton(self.statue_interact_container,
														borderwidth=0,
														variable=projectile_props["statue_interact"][0])
		self.statue_interact_checkbox.pack(side=tk.LEFT)
		self.statue_interact_label = tk.Label(self.statue_interact_container,text=projectile_props["statue_interact"][2])
		self.statue_interact_label.pack(side=tk.LEFT)
		
		self.statue_disable_container.pack(fill="x")
		self.statue_interact_container.pack(fill="x")
		
	def mini_configuration(self, main_widget):
		self.mini_config_widget = tk.LabelFrame(main_widget, text="Mini Mario", padx=5, pady=5)
		self.mini_config_widget.pack(fill="both", padx=3, pady=1)
		
		self.mini_interaction_container = tk.Frame(self.mini_config_widget)
		self.mini_interaction_label = tk.Label(self.mini_interaction_container,text=projectile_props["mini_interaction"][2])
		self.mini_interaction_label.pack(side=tk.LEFT)
		self.mini_interaction_combo_box = ttk.Combobox(self.mini_interaction_container,
														 state="readonly",
														 height=20,
														 width=15,
														 values=["Disabled",
																 "Default",
																 "Check contact",
																 "Bounce off"])
		self.mini_interaction_combo_box.bind("<<ComboboxSelected>>", self.selected_mini_interaction)
		self.mini_interaction_combo_box.current(projectile_props["mini_interaction"][0].get())
		self.mini_interaction_combo_box.pack(side=tk.LEFT)
		
		self.mini_interaction_container.pack(fill="x")
		
	def selected_mini_interaction(self, event):
		projectile_props["mini_interaction"][0].set(self.mini_interaction_combo_box.current())
		
	def shell_configuration(self, main_widget):
		self.shell_config_widget = tk.LabelFrame(main_widget, text="Shell Mario", padx=5, pady=5)
		self.shell_config_widget.pack(fill="both", padx=3, pady=1, expand=True)
		
		self.shell_interaction_container = tk.Frame(self.shell_config_widget)
		self.shell_interaction_label = tk.Label(self.shell_interaction_container,text=projectile_props["shell_interaction"][2])
		self.shell_interaction_label.pack(side=tk.LEFT)
		self.shell_interaction_combo_box = ttk.Combobox(self.shell_interaction_container,
														 state="readonly",
														 height=20,
														 width=15,
														 values=["Disabled",
																 "Default",
																 "Solid",
																 "Kill, fall down",
																 "Kill, spin jump",
																 "Unused",
																 "Unused",
																 "Unused"])
		self.shell_interaction_combo_box.bind("<<ComboboxSelected>>", self.selected_shell_interaction)
		self.shell_interaction_combo_box.current(projectile_props["shell_interaction"][0].get())
		self.shell_interaction_combo_box.pack(side=tk.LEFT)
		
		self.shell_interaction_container.pack(fill="x")
		
	def selected_shell_interaction(self, event):
		projectile_props["shell_interaction"][0].set(self.shell_interaction_combo_box.current())
		
	def cat_configuration(self, main_widget):
		self.cat_config_widget = tk.LabelFrame(main_widget, text="Cat scratch", padx=5, pady=5)
		self.cat_config_widget.pack(fill="x", padx=3, pady=1)
		
		self.cat_scratch_container = tk.Frame(self.cat_config_widget)
		self.cat_scratch_checkbox = tk.Checkbutton(self.cat_scratch_container,
														borderwidth=0,
														variable=projectile_props["cat_scratch"][0])
		self.cat_scratch_checkbox.pack(side=tk.LEFT)
		self.cat_scratch_label = tk.Label(self.cat_scratch_container,text=projectile_props["cat_scratch"][2])
		self.cat_scratch_label.pack(side=tk.LEFT)
		
		self.cat_scratch_container.pack(fill="x")
		
###########################################################
		
	def update_sprite_data(self):
		global current_sprite
						
		data = settings["hammer"][current_sprite]
		projectile_props["hammer_immunity"][0].set((data>>projectile_props["hammer_immunity"][1])&1)
		projectile_props["hammer_disable"][0].set((data>>projectile_props["hammer_disable"][1])&1)
		
		data = settings["boomerang"][current_sprite]
		projectile_props["boomerang_immunity"][0].set((data>>projectile_props["boomerang_immunity"][1])&1)
		projectile_props["boomerang_disable"][0].set((data>>projectile_props["boomerang_disable"][1])&1)
		projectile_props["boomerang_retrieve"][0].set((data>>projectile_props["boomerang_retrieve"][1])&3)
		
		data = settings["iceball"][current_sprite]
		projectile_props["iceball_immunity"][0].set((data>>projectile_props["iceball_immunity"][1])&1)
		projectile_props["iceball_disable"][0].set((data>>projectile_props["iceball_disable"][1])&1)
		projectile_props["iceball_coin"][0].set((data>>projectile_props["iceball_coin"][1])&1)
		projectile_props["iceball_block_size"][0].set((data>>projectile_props["iceball_block_size"][1])&3)
		projectile_props["iceball_smoke"][0].set((data>>projectile_props["iceball_smoke"][1])&1)
		projectile_props["iceball_x_disp"][0].set((data>>projectile_props["iceball_x_disp"][1])&1)
		projectile_props["iceball_y_disp"][0].set((data>>projectile_props["iceball_y_disp"][1])&1)
		self.iceball_block_size_combo_box.current(projectile_props["iceball_block_size"][0].get())
		
		data = settings["superball"][current_sprite]
		projectile_props["superball_immunity"][0].set((data>>projectile_props["superball_immunity"][1])&1)
		projectile_props["superball_disable"][0].set((data>>projectile_props["superball_disable"][1])&1)
		
		data = settings["bubble"][current_sprite]
		projectile_props["bubble_immunity"][0].set((data>>projectile_props["bubble_immunity"][1])&1)
		projectile_props["bubble_disable"][0].set((data>>projectile_props["bubble_disable"][1])&1)
		
		data = settings["elecball"][current_sprite]
		projectile_props["elecball_paralyzed"][0].set((data>>projectile_props["elecball_paralyzed"][1])&1)
		projectile_props["elecball_disable"][0].set((data>>projectile_props["elecball_disable"][1])&1)
		projectile_props["elecball_fx_size"][0].set((data>>projectile_props["elecball_fx_size"][1])&15)
		projectile_props["elecball_instakill"][0].set((data>>projectile_props["elecball_instakill"][1])&1)
		projectile_props["elecball_pierce"][0].set((data>>projectile_props["elecball_pierce"][1])&1)
		self.elecball_fx_size_combo_box.current(projectile_props["elecball_fx_size"][0].get())
		
		data = settings["statue"][current_sprite]
		projectile_props["statue_disable"][0].set((data>>projectile_props["statue_disable"][1])&1)
		projectile_props["statue_interact"][0].set((data>>projectile_props["statue_interact"][1])&1)
		
		data = settings["mini"][current_sprite]
		projectile_props["mini_interaction"][0].set(data>>projectile_props["mini_interaction"][1]&3)
		self.mini_interaction_combo_box.current(projectile_props["mini_interaction"][0].get())
		
		data = settings["shell"][current_sprite]
		projectile_props["shell_interaction"][0].set(data>>projectile_props["shell_interaction"][1]&7)
		self.shell_interaction_combo_box.current(projectile_props["shell_interaction"][0].get())
		
		data = settings["cat"][current_sprite]
		projectile_props["cat_scratch"][0].set((data>>projectile_props["cat_scratch"][1])&1)
		
	def save_sprite_data(self):
		global current_sprite
		
		data = ((projectile_props["hammer_immunity"][0].get()<<projectile_props["hammer_immunity"][1])|
				(projectile_props["hammer_disable"][0].get()<<projectile_props["hammer_disable"][1]))
		settings["hammer"][current_sprite] = data
				
		data = ((projectile_props["boomerang_immunity"][0].get()<<projectile_props["boomerang_immunity"][1])|
				(projectile_props["boomerang_disable"][0].get()<<projectile_props["boomerang_disable"][1])|
				(projectile_props["boomerang_retrieve"][0].get()<<projectile_props["boomerang_retrieve"][1]))
		settings["boomerang"][current_sprite] = data
		
		data = ((projectile_props["iceball_immunity"][0].get()<<projectile_props["iceball_immunity"][1])|
				(projectile_props["iceball_coin"][0].get()<<projectile_props["iceball_coin"][1])|
				(projectile_props["iceball_block_size"][0].get()<<projectile_props["iceball_block_size"][1])|
				(projectile_props["iceball_disable"][0].get()<<projectile_props["iceball_disable"][1])|
				(projectile_props["iceball_smoke"][0].get()<<projectile_props["iceball_smoke"][1])|
				(projectile_props["iceball_x_disp"][0].get()<<projectile_props["iceball_x_disp"][1])|
				(projectile_props["iceball_y_disp"][0].get()<<projectile_props["iceball_y_disp"][1]))
		settings["iceball"][current_sprite] = data
		
		data = ((projectile_props["superball_immunity"][0].get()<<projectile_props["superball_immunity"][1])|
				(projectile_props["superball_disable"][0].get()<<projectile_props["superball_disable"][1]))
		settings["superball"][current_sprite] = data
		
		data = ((projectile_props["bubble_immunity"][0].get()<<projectile_props["bubble_immunity"][1])|
				(projectile_props["bubble_disable"][0].get()<<projectile_props["bubble_disable"][1]))
		settings["bubble"][current_sprite] = data
			
		data = ((projectile_props["elecball_paralyzed"][0].get()<<projectile_props["elecball_paralyzed"][1])|
				(projectile_props["elecball_disable"][0].get()<<projectile_props["elecball_disable"][1])|
				(projectile_props["elecball_fx_size"][0].get()<<projectile_props["elecball_fx_size"][1])|
				(projectile_props["elecball_instakill"][0].get()<<projectile_props["elecball_instakill"][1])|
				(projectile_props["elecball_pierce"][0].get()<<projectile_props["elecball_pierce"][1]))
		settings["elecball"][current_sprite] = data
		
		data = ((projectile_props["statue_disable"][0].get()<<projectile_props["statue_disable"][1])|
				(projectile_props["statue_interact"][0].get()<<projectile_props["statue_interact"][1]))
		settings["statue"][current_sprite] = data
		
		data = (projectile_props["mini_interaction"][0].get()<<projectile_props["mini_interaction"][1])&3
		settings["mini"][current_sprite] = data
		
		data = (projectile_props["shell_interaction"][0].get()<<projectile_props["shell_interaction"][1])&7
		settings["shell"][current_sprite] = data
		
		data = ((projectile_props["cat_scratch"][0].get()<<projectile_props["cat_scratch"][1]))
		settings["cat"][current_sprite] = data
		
if __name__ == "__main__":
	root = tk.Tk()
	
	current_sprite = 0
	
	projectile_vars = []
	for i in range(26):
		projectile_vars.append(tk.IntVar())
				
	projectile_props = {
		"hammer_immunity": [
			projectile_vars[0],
			0,
			"Immune to hammers"
		],
		"hammer_disable": [
			projectile_vars[1],
			4,
			"Disable interaction with hammers"
		],
		
		
		"boomerang_immunity": [
			projectile_vars[2],
			0,
			"Immune to boomerangs"
		],
		"boomerang_disable": [
			projectile_vars[3],
			4,
			"Disable interaction with boomerangs"
		],
		"boomerang_retrieve": [
			projectile_vars[4],
			6,
			"Can be retrieved by boomerangs"
		],
		
		
		"iceball_immunity": [
			projectile_vars[5],
			1,
			"Immune to iceballs"
		],
		"iceball_coin": [
			projectile_vars[6],
			0,
			"Ice block has a coin inside"
		],
		"iceball_block_size": [
			projectile_vars[7],
			2,
			"Ice block size: "
		],
		"iceball_disable": [
			projectile_vars[8],
			4,
			"Disable interaction with iceballs"
		],
		"iceball_smoke": [
			projectile_vars[9],
			5,
			"Disappears in cloud of smoke"
		],
		"iceball_x_disp": [
			projectile_vars[10],
			6,
			"Displace ice block 8px to the left"
		],
		"iceball_y_disp": [
			projectile_vars[11],
			7,
			"Displace ice block 16px upwards"
		],
		
		
		"superball_immunity":  [
			projectile_vars[12],
			0,
			"Immune to superballs"
		],
		"superball_disable":  [
			projectile_vars[13],
			4,
			"Disable interaction with superballs"
		],
		
		
		"bubble_immunity":  [
			projectile_vars[14],
			2,
			"Immune to bubbles"
		],
		"bubble_disable":  [
			projectile_vars[15],
			4,
			"Disable interaction with bubbles"
		],
		
		"elecball_pierce":  [
			projectile_vars[16],
			5,
			"Disappear elecball on contact"
		],
		"elecball_disable":  [
			projectile_vars[17],
			4,
			"Disable interaction with elecballs"
		],
		"elecball_paralyzed":  [
			projectile_vars[18],
			6,
			"Can't be paralyzed by elecballs"
		],
		"elecball_instakill":  [
			projectile_vars[19],
			7,
			"Can be defeated when electrified"
		],
		"elecball_fx_size":  [
			projectile_vars[20],
			0,
			"Electricity FX size: "
		],
		
		"statue_disable": [
			projectile_vars[21],
			3,
			"Can't be killed by Tanooki's statue"
		],
		"statue_interact": [
			projectile_vars[22],
			5,
			"Run default interaction with Tanooki's statue"
		],
		
		"mini_interaction": [
			projectile_vars[23],
			0,
			"Mini Mario behavior: "
		],
		
		"shell_interaction": [
			projectile_vars[24],
			0,
			"Shell Mario behavior: "
		],
		
		"cat_scratch": [
			projectile_vars[25],
			0,
			"Can't be killed by Cat Mario's scratch"
		]
		
	}	
	
	sprite_names = []
	hammer_settings = []
	boomerang_settings = []
	iceball_settings = []
	superball_settings = []
	bubble_settings = []
	elecball_settings = []
	statue_settings = []
	mini_settings = []
	shell_settings = []
	cat_settings = []
	
	settings = {
		"hammer": [],
		"boomerang": [],
		"iceball": [],
		"superball": [],
		"bubble": [],
		"elecball": [],
		"statue": [],
		"mini": [],
		"shell": [],
		"cat": []
	}
	
	for i in range(512):
		sprite_names.append("")
		settings["hammer"].append(0)
		settings["boomerang"].append(0)
		settings["iceball"].append(0)
		settings["superball"].append(0)
		settings["bubble"].append(0)
		settings["elecball"].append(0)
		settings["statue"].append(0)
		settings["mini"].append(0)
		settings["shell"].append(0)
		settings["cat"].append(0)
								
	toolbar = Toolbar(root)
	mainframe = MainFrame(root)
	root.title("Custom Powerup Sprite Config")
	root.geometry("600x515")
	root.resizable(False, False)
	
	icondata = base64.b64decode(icon)
	tempFile = "_icon.ico"
	iconfile = open(tempFile,"wb")
	iconfile.write(icondata)
	iconfile.close()
	root.iconbitmap(tempFile)
	os.remove(tempFile)
	
	root.mainloop()
	
	
	
	