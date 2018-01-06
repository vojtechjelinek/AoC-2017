<?php
    function count_severity($firewall, $offset) {
        $severity = 0;
        foreach ($firewall as $range => $depth) {
            if (($range + $offset) % (2 * ($depth - 1)) == 0) {
                $severity += ($range + $offset) * $depth;
            }
        }
        return $severity;
    }

    $f = fopen("input.txt", "r");
    $firewall = array();
    while($line = fgets($f)) {
        $values = explode(": ", $line);
        $firewall[(int) $values[0]] = ((int) $values[1]);
    }
    echo count_severity($firewall, 0) . "\n";

    $i = 1;
    while (count_severity($firewall, $i++) != 0);
    echo $i;
?>
