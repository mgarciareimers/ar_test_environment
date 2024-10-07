package com.mgarciareimers.ar_test_environment.activities;

import android.content.Intent;
import android.os.Bundle;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.cardview.widget.CardView;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

import com.mgarciareimers.ar_test_environment.R;

public class MainActivity extends AppCompatActivity {
    private CardView placeCardView;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_main);
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main), (v, insets) -> {
            Insets systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars());
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom);
            return insets;
        });

        defineFields();
        defineOnClickListeners();
    }

    // Method that defines the fields.
    private void defineFields() {
        placeCardView = findViewById(R.id.placeCardView);
    }

    // Method that defines the onclick listeners.
    private void defineOnClickListeners() {
        placeCardView.setOnClickListener(view -> startActivity(new Intent(this, PlaceActivity.class)));
    }
}