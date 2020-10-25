;;;======================================================
;;;   Smartphone Expert System
;;;
;;;     This expert system diagnoses some simple
;;;     problems with a Smartphone.
;;;
;;;     CLIPS Version 6.3 
;;;
;;;     To execute, merely load, reset and run.
;;;======================================================

;;****************
;;* DEFFUNCTIONS *
;;****************

(deffunction ask-question (?question $?allowed-values)
   (printout t ?question)
   (bind ?answer (read))
   (if (lexemep ?answer) 
       then (bind ?answer (lowcase ?answer)))
   (while (not (member ?answer ?allowed-values)) do
      (printout t ?question)
      (bind ?answer (read))
      (if (lexemep ?answer) 
          then (bind ?answer (lowcase ?answer))))
   ?answer)

(deffunction yes-or-no-p (?question)
   (bind ?response (ask-question ?question yes no y n))
   (if (or (eq ?response yes) (eq ?response y))
       then yes 
       else no))

;;;***************
;;;* QUERY RULES *
;;;***************
;;; smartphone menyala

(defrule determine-smartphone-state ""
   (not (smartphone-hidup ?))
   (not (repair ?))
   =>
   (assert (smartphone-hidup (yes-or-no-p "Apakah smartphone menyala saat tombol power ditekan (yes/no)? "))))

(defrule determine-booting ""
   (smartphone-hidup yes)
   (not (repair ?))
   =>
   (assert (booting-start (yes-or-no-p "Apakah booting smartphone berjalan (yes/no)? "))))

(defrule determine-booting-normal ""
    (smartphone-hidup yes)
	(not (repair ?))
   =>
   (assert (booting-normally (yes-or-no-p "Apakah booting smartphone berjalan normal(yes/no)? "))))

(defrule determine-aplikasi ""
   (smartphone-hidup yes)
	(not (repair ?))
   =>
   (assert (jalankan-aplikasi (yes-or-no-p "Apakah saat menjalankan aplikasi berjalan normal(yes/no)? "))))

(defrule determine-casing-state ""
   (smartphone-hidup no)
   (not (repair ?))   
   =>
   (assert (casing-retak (yes-or-no-p "apakah casing smartphone retak (yes/no)? "))))
   
(defrule determine-screen-state ""
   (smartphone-hidup no)
   (not (repair ?))
   =>
   (assert (screen-retak (yes-or-no-p "apakah layar smartphone retak/pecah (yes/no)? "))))
   
(defrule determine-fluid ""
   (smartphone-hidup no)
   (not (repair ?))
   =>
   (assert (smartphone-fluid (yes-or-no-p "apakah terdapat cairan pada smartphone (yes/no)? "))))

(defrule determine-screen-off ""
   (smartphone-hidup no)
   (not (repair ?))
   =>
   (assert (smartphone-screen-off (yes-or-no-p "apakah layar smartphone mati (yes/no)? "))))

(defrule determine-charge ""
   (smartphone-hidup no)
   (not (repair ?))
   =>
   (assert (smartphone-charge (yes-or-no-p "apakah smartphone dapat mengisi daya (yes/no)? "))))
 
(defrule determine-baterai ""
   (smartphone-hidup no)
   (not (repair ?))
   =>
   (assert (baterai (yes-or-no-p "Apakah baterai menyala (yes/no)? "))))


;;;****************
;;;* REPAIR RULES *
;;;****************
(defrule smartphone-baik ""
   (jalankan-aplikasi yes)
   (not (repair ?))
   =>
   (assert (repair "Smartphone anda baik - baik saja.")))

(defrule fluid   ""
   (smartphone-fluid  yes)
   (not (repair ?))
   =>
   (assert (repair "Terdapat Air didalam Smartphone anda, keringkan dengan hair dryer")))

(defrule screen-retak-casing-retak   ""
   (screen-retak  yes)
   (casing-retak  yes)
   (smartphone-fluid  no)
   (not (repair ?))
   =>
   (assert (repair "Segera ganti layar dan casing smartphone anda")))

(defrule bluescreen ""
  (jalankan-aplikasi no)
  (not (repair ?))
  =>
  (assert (repair "Uninstall aplikasi yang bermasalah tersebut")))
  
(defrule booting-berulang ""
  (booting-normally no)
  (not (repair ?))
  =>
  (assert (repair "Perbaiki smartphone anda ke reparasi smartphone")))

(defrule smartphone-screen ""
  (smartphone-screen-off yes)
  (smartphone-charge yes)
  (baterai yes)
  (not (repair ?))
  =>
  (assert (repair "Layar smartphone anda bermasalah, Bawa smartphone anda ke reparasi smartphone")))

(defrule smartphone-charge ""
  (smartphone-charge no)
  (baterai yes)
  (not (repair ?))
  =>
  (assert (repair "Charger smartphone anda bermasalah, Segera ganti Charger smartphone anda")))
	  
(defrule baterai-mati ""
  (smartphone-charge no)
  (baterai no)
  (not (repair ?))
  =>
  (assert (repair "Baterai smartphone anda bermasalah, Bawa smartphone anda ke reparasi smartphone")))
  

(defrule no-repairs ""
  (declare (salience -10))
  (not (repair ?))
  =>
  (assert (repair "Perbaiki smartphone anda ke reparasi smartphone")))

;;;********************************
;;;* STARTUP AND CONCLUSION RULES *
;;;********************************

(defrule system-banner ""
  (declare (salience 10))
  =>
  (printout t crlf crlf)
  (printout t "The Engine Diagnosis Expert System")
  (printout t crlf crlf))

(defrule print-repair ""
  (declare (salience 10))
  (repair ?item)
  =>
  (printout t crlf crlf)
  (printout t "Suggested Repair:")
  (printout t crlf crlf)
  (format t " %s%n%n%n" ?item))
