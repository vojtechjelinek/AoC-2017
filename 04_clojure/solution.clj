(require '[clojure.string :as str])

(def get_sorted_lines
  (fn [lines]
    (map #(map sort %) lines)))

(def has_not_duplicate
  (fn [lines]
    (map #(= (count (distinct %)) (count %)) lines)))

(def count_true
  (fn [list]
    (count (filter #(= % true) list))))

(def formated (map #(str/split % #" ") (str/split (slurp "input.txt") #"\n")))

(println (count_true (has_not_duplicate formated)))
(println (count_true (has_not_duplicate (get_sorted_lines formated))))
