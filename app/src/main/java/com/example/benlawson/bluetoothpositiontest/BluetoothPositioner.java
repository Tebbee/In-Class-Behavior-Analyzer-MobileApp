package com.example.benlawson.bluetoothpositiontest;

import android.graphics.Typeface;
import android.os.Build;
import android.support.annotation.RequiresApi;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.example.benlawson.bluetoothpositiontest.BluetoothFiles.EnvironmentSettings;
import com.example.benlawson.bluetoothpositiontest.BluetoothFiles.Triangulator;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;

@RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR2)
public class BluetoothPositioner extends AppCompatActivity {
    private ArrayList<String> deviceNameFilters;
    private Button backButton, scanButton, stopScanningButton;
    private LinearLayout rssiValuesList;
    private RSSIBTScanner scanner;
    private ProgressBar scanningProgress;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_bluetooth_positioner);

        //noinspection unchecked
        deviceNameFilters = (ArrayList<String>) getIntent().getSerializableExtra("SelectedDevices");
        scanner = new RSSIBTScanner(this);

        backButton = findViewById(R.id.backButton);
        scanButton = findViewById(R.id.scanForRSSIButton);
        stopScanningButton = findViewById(R.id.stopScanningButton);
        rssiValuesList = findViewById(R.id.RSSIValuesButton);
        scanningProgress = findViewById(R.id.scanningInProgress);

        scanButton.setOnClickListener(new Button.OnClickListener() {
            @Override
            public void onClick(View v) {
                rssiValuesList.removeAllViews();
                scanner.setNameFilters(deviceNameFilters);
                scanner.beginScanNearbyDevices();
                stopScanningButton.setEnabled(true);
                scanButton.setEnabled(false);
                scanningProgress.setVisibility(View.VISIBLE);
            }
        });

        stopScanningButton.setOnClickListener(new Button.OnClickListener() {
            @Override
            public void onClick(View v) {
                scanner.stopScanning();
                scanButton.setEnabled(true);
                stopScanningButton.setEnabled(false);
                scanningProgress.setVisibility(View.INVISIBLE);
            }
        });

        backButton.setOnClickListener(new Button.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

    }

    public void finishedScanningRepeatedCallback(final HashMap<String, LinkedList<Integer>> rssiValues) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (scanningProgress.getVisibility() == View.VISIBLE) scanningProgress.setVisibility(View.INVISIBLE);
                rssiValuesList.removeAllViews();
                HashMap<String, Double> distanceValues = new HashMap<>();

                for (String deviceName: rssiValues.keySet()) {
                    int total = 0;
                    for (int rssiValue: rssiValues.get(deviceName)) {
                        total += rssiValue;
                    }
                    double average = total * 1.0 / RSSIBTScanner.scanTimes;
                    double distanceInMeters = Math.pow(10, (EnvironmentSettings.MEASURED_POWER - average) / (10 * EnvironmentSettings.ENVIRONMENT_VALUE));
                    double distanceInFeet = distanceInMeters / 0.3048;

                    TextView deviceNameView = new TextView(getBaseContext());
                    deviceNameView.setText(deviceName);
                    rssiValuesList.addView(deviceNameView);

                    TextView rssiValueView = new TextView(getBaseContext());
                    rssiValueView.setText("\tRSSI: " + String.valueOf(average) + "dBm");
                    rssiValuesList.addView(rssiValueView);

                    TextView distanceView = new TextView(getBaseContext());
                    distanceView.setText("\tDistance: " + String.valueOf(distanceInFeet) + " ft");
                    rssiValuesList.addView(distanceView);

                    distanceValues.put(deviceName, distanceInFeet);
                }

                double [] point = Triangulator.calculateThreeCircleIntersection(0,0,distanceValues.get("BLE-Beacon-1"), 7.3333, 6.6667, distanceValues.get("BLE-Beacon-2"), 14.6667, 2.3333, distanceValues.get("BLE-Beacon-3"));
                String pointText = "";
                if (point == null) pointText = "ERROR: Calculation in point mathematics";
                else {
                    pointText = String.format("Estimated Point: (%f, %f)", point[0], point[1]);
                }
                TextView pointView = new TextView(getBaseContext());
                pointView.setText(pointText);
                pointView.setTypeface(null, Typeface.BOLD);
                rssiValuesList.addView(pointView);
            }
        });

    }

}
